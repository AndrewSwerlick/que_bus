module QueBus
  class Railtie < Rails::Railtie
    rake_tasks do
      load "que_bus/rake_tasks.rb"
    end

    initializer "set subscription_namespace" do
      QueBus.subscription_namespace = Rails.application.class.parent_name
    end
  end
end
