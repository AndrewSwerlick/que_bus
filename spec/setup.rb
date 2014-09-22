require 'active_record'

require File.expand_path('../../lib/que_bus.rb',__FILE__)

include QueBus
ActiveRecord::Base.establish_connection(
  :adapter  => "postgresql",
  :database => "qb"
)

Que.connection = ActiveRecord
Que.migrate!
QueBus.migrate!
