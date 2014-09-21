module QueBus
  class Railtie < Rails::Railtie
    rake_tasks do
      load "que_bus/rake_tasks.rb"
    end
  end
end
