require 'minitest/autorun'
require 'minitest/pride'
require 'active_record'
require 'byebug'

require File.expand_path('../../lib/que_bus.rb',__FILE__)

include QueBus
ActiveRecord::Base.establish_connection(
  :adapter  => "postgresql",
  :database => "que_bus"
)

Que.connection = ActiveRecord
Que.mode = :sync
Que.migrate!
