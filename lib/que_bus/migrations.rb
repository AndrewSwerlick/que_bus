# copied from the que library. TODO: determine if there's a better way to handle
module QueBus
  module Migrations
    # In order to ship a schema change, add the relevant up and down sql files
    # to the migrations directory, and bump the version both here and in the
    # add_que generator template.
    CURRENT_VERSION = 2

    class << self
      def migrate!(options = {:version => CURRENT_VERSION})
        transaction do
          version = options[:version]

          if (current = db_version) == version
            return
          elsif current < version
            direction = 'up'
            steps = ((current + 1)..version).to_a
          elsif current > version
            direction = 'down'
            steps = ((version + 1)..current).to_a.reverse
          end

          steps.each do |step|
            sql = File.read("#{File.dirname(__FILE__)}/migrations/#{step}/#{direction}.sql")
            Que.execute(sql)
          end

          set_db_version(version)
        end
      end

      def db_version
        result = Que.execute <<-SQL
          SELECT relname, description
          FROM pg_class
          LEFT JOIN pg_description ON pg_description.objoid = pg_class.oid
          WHERE relname = 'que_bus_subscribers'
        SQL

        if result.none?
          # No table in the database at all.
          0
        elsif (d = result.first[:description]).nil?
          # There's a table, it was just created before the migration system existed.
          1
        else
          d.to_i
        end
      end

      def set_db_version(version)
        i = version.to_i
        Que.execute "COMMENT ON TABLE que_bus_subscribers IS '#{i}'" unless i.zero?
      end

      def transaction
        Que.adapter.checkout do
          if Que.adapter.in_transaction?
            yield
          else
            begin
              Que.execute "BEGIN"
              yield
            rescue => error
              raise
            ensure
              # Handle a raised error or a killed thread.
              if error || Thread.current.status == 'aborting'
                Que.execute "ROLLBACK"
              else
                Que.execute "COMMIT"
              end
            end
          end
        end
      end
    end
  end
end
