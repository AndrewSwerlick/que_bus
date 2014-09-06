require 'minitest/autorun'
require 'minitest/pride'
require 'byebug'
require 'database_cleaner'
require_relative 'setup'

Que.mode = :sync
DatabaseCleaner.strategy = :transaction

class MiniTest::Spec
  before :each do
    DatabaseCleaner.start
    QueBus::Jobs.constants.each do |c|
      QueBus::Jobs.send(:remove_const, c)
    end
  end

  after :each do
    DatabaseCleaner.clean
  end
end
