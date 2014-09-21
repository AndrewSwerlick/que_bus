module QueBus
  class Railtie < Rails::Railtie
    rake_tasks do
      load "que_bus/tasks"
    end
  end
end
