require "que_bus/version"
require 'securerandom'
require 'que'

module QueBus
  autoload :Migrations, 'que_bus/migrations'
  autoload :Bus, "que_bus/bus"
  autoload :Subscriber, "que_bus/subscriber"
  autoload :BusWorker, "que_bus/bus_worker"

  # monkey patch Que so it doesn't generate it's own workers. We manage our own
  # workers in the BusWorker class, and we don't want the underlying library
  # interfering.
  class << Que::Worker
    def set_up_workers
    end
  end

  BusWorker.mode = :async

  class << self
    attr_reader :jobs_array

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
