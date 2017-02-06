require "que_bus/version"
require 'securerandom'
require 'que'

module QueBus
  autoload :Migrations, 'que_bus/migrations'
  autoload :Bus, "que_bus/bus"
  autoload :Subscriber, "que_bus/subscriber"
  autoload :Event, "que_bus/event"
  autoload :BusWorker, "que_bus/bus_worker"
  autoload :Listener, "que_bus/listener"
  autoload :Publisher, "que_bus/publisher"

  class << self
    attr_reader :jobs_array
    attr_accessor :subscription_namespace

    def migrate!(version = {:version => Migrations::CURRENT_VERSION})
      Migrations.migrate!(version)
    end

    def mode
      BusWorker.mode
    end

    def mode=(mode)
      Que.mode = mode
      BusWorker.mode = mode
    end

    # Store subscription code to be run in the rake task
    # after QueBus has been properly configured
    def jobs(&block)
      @jobs_array = (@jobs_array || []) << block
    end
  end

  require 'que_bus/railtie' if defined? Rails::Railtie
end
