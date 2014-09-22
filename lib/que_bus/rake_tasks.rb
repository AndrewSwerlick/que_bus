namespace :quebus do
  desc "start a process that listens to the que event bus"
  task :listen => :environment do
    QueBus.mode = :async

    if QueBus::Migrations.db_version == QueBus::Migrations::CURRENT_VERSION
      QueBus.jobs_array.each do |b|
        b.call
      end
    end

    stop = false
    %w( INT TERM ).each do |signal|
      trap(signal) {stop = true}
    end

    at_exit do
      $stdout.puts "Finishing Que's current jobs before exiting..."
      QueBus.mode = :off
      $stdout.puts "Que's jobs finished, exiting..."
    end

    loop do
      sleep 0.01
      break if stop
    end
  end

  desc "Migrate QueBus's job and subscribers table to the most recent version (creating it if it doesn't exist)"
  task :migrate => :environment do
    Que.migrate!
    QueBus.migrate!
  end
end
