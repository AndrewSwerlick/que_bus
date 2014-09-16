require 'minitest/autorun'
require 'minitest/pride'
require 'byebug'
require 'database_cleaner'
require_relative 'setup'
require 'evented-spec'



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
