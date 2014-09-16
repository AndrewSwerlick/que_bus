class InstallGenerator < Rails::Generators::Base
  namespace 'quebus:install'

  def create_initializer_file
    create_file "config/initializers/que_bus.rb", self.contents
  end

  def self.contents
    %{
      #Turns the bus off. This is default for rails because generally the bus will run in a rake task
      QueBus.mode = :off

      #write your subscribe logic here. This file will be loaded during initialization of the rake task.
      #example
      #QueBus.subscribe do
      # ..respond to published events here
      #end
    }
  end
end
