require 'byebug'
require 'active_record'
require 'que_bus'

unless ENV['DATABASE_URL']
  require 'dotenv'
  Dotenv.load
end

ActiveRecord::Base.establish_connection()
Que.connection = ActiveRecord
