require "que_bus/version"
require 'securerandom'
require 'que'

module QueBus
  autoload :Migrations, 'que_bus/migrations'
  autoload :Bus, "que_bus/bus"
  autoload :Subscriber, "que_bus/subscriber"
  autoload :BusWorker, "que_bus/bus_worker"

  def migrate!(version = {:version => Migrations::CURRENT_VERSION})
    Migrations.migrate!(version)
  end

  #disable Que so it doesn't create workers to process things.
  #We manage our own workers using the BusWorker class
  Que.mode = :off

  BusWorker.mode = :async

  def mode
    BusWorker.mode
  end

  def mode=(mode)
    if mode == :sync
      Que.mode = :sync
    else
      Que.mode = :off
    end

    BusWorker.mode = mode
  end

  #require 'que_bus/railtie' if defined? Rails::Railtie
end
