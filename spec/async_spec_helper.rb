require 'minitest/autorun'
require 'minitest/pride'
require 'byebug'
require 'database_cleaner'
require 'evented-spec'
require 'active_record'
require 'que_bus'

unless ENV['DATABASE_URL']
  require 'dotenv'
  Dotenv.load
end

ActiveRecord::Base.establish_connection()
Que.connection = ActiveRecord

class MiniTest::Spec
  def eventually(opts = {})
    interval = opts.delete(:interval) || 0.001
    timeout = opts.delete(:timeout) || 1
    total = 0
    begin
      sleep interval
      total = total + interval
      yield
    rescue MiniTest::Assertion => e
      retry if total < timeout
      raise e total >= timeout
    end
  end


  before :each do
    QueBus::BusWorker.wake_interval = 0.1
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
    QueBus::Jobs.constants.each do |c|
      QueBus::Jobs.send(:remove_const, c)
    end
    Que.mode = :off
    QueBus.mode = :async
  end

  after :each do
    DatabaseCleaner.clean
  end
end
