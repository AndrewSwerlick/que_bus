module QueBus
  class InstallGenerator < Rails::Generators::Base
    def create_initializer_file
      create_file "config/initializers/que_bus.rb", contents
    end

    def contents
      %{
# Turns the bus off. This is default for rails because generally the bus listener will run in a rake task
# if you want the bus listener to run in the same process as the webserver then change to :async
QueBus.mode = :off


QueBus.jobs do
  # write your subscribe logic here. This file will be loaded during initialization of the rake task.
  # example

  # QueBus::Bus.new.subscribe "test" do
  #   puts "hi"
  # end
end
      }
    end
  end
end
