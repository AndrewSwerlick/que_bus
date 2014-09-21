namespace :quebus do
  desc "start a process that listens to the que event bus"
  task :listen => :environment do

    QueBus.mode = :async
  end
end
