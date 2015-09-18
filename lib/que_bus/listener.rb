module QueBus
  module Listener

    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        job = Class.new(Que::Job) do
          def run(*args)
            ActiveRecord::Base.transaction do
              method = self.class.parent.get_execution_method
              args_hash = {
                message: args[0]
                options: args[1]
              }
              self.class.parent.send(method, args_hash)
              destroy
            end
          end
        end
        base.const_set(:Job, job)
      end
    end

    module ClassMethods
      def subscribe
        bus = QueBus::Bus.new
        bus.subscribe id: self.name, class: self::Job, topics: self.topics_list
      end

      def topics(*topics)
        @topics = topics
      end

      def topics_list
        @topics
      end

      def exec_method(method)
        @method = method
      end

      def get_execution_method
        @method || :run
      end
    end
  end
end
