require 'minitest/autorun'
require 'minitest/pride'
require 'byebug'
require 'database_cleaner'
require_relative 'setup'
require 'evented-spec'


class MiniTest::Spec
  before :each do
    QueBus::BusWorker.wake_interval = 0.1
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
    QueBus::Jobs.constants.each do |c|
      QueBus::Jobs.send(:remove_const, c)
    end
    Que.mode = :off
    QueBus::BusWorker.mode = :async
  end

  after :each do
    DatabaseCleaner.clean
  end
end
