namespace :quebus do
  task :listen => :environment do

    QueBus.mode = :async
  end
end
