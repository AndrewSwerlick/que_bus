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

  Que.mode = :off

  BusWorker.mode = :async
end
