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
  before :each do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    QueBus::Jobs.constants.each do |c|
      QueBus::Jobs.send(:remove_const, c)
    end
    QueBus.mode = :sync
  end

  after :each do
    DatabaseCleaner.clean
  end
end
