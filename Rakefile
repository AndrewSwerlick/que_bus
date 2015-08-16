#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rake/testtask'
require 'que_bus'


namespace :test do
  Rake::TestTask.new(:sync) do |t|
    t.libs << 'lib/que_bus'
    t.libs << 'spec'
    t.test_files = FileList['spec/que_bus/*_spec.rb'].exclude('spec/que_bus/async_*_spec.rb')
  end

  Rake::TestTask.new(:async) do |t|
    t.libs << 'lib/que_bus'
    t.libs << 'spec'
    t.test_files = FileList['spec/que_bus/async_*_spec.rb']
  end

  task :default => :sync
end

task :irb do
  require_relative 'spec/interactive_helper'
  require 'irb'
  ARGV.clear
  QueBus.mode = :async
  IRB.start
end

task :default => "test:default"

task :setup do
  if File.exist?('.env')
    puts 'This will overwrite your existing .env file'
  end
  print 'Enter your database name: [qb_test] '
  db_name = STDIN.gets.chomp
  print 'Enter your database user: [] '
  db_user = STDIN.gets.chomp
  print 'Enter your database password: [] '
  db_password = STDIN.gets.chomp
  print 'Enter your database server: [localhost] '
  db_server = STDIN.gets.chomp

  db_name = 'qb_test' if db_name.empty?
  db_password = ":#{db_password}" unless db_password.empty?
  db_server = 'localhost' if db_server.empty?

  db_server = "@#{db_server}" unless db_user.empty?

  env_path = File.expand_path('./.env')
  File.open(env_path, 'w') do |file|
    file.puts "DATABASE_NAME=#{db_name}"
    file.puts "DATABASE_URL=\"postgres://#{db_user}#{db_password}#{db_server}/#{db_name}\""
  end

  puts '.env file saved'
end

namespace :db do
  task :load_db_settings do
    require 'active_record'
    unless ENV['DATABASE_URL']
      require 'dotenv'
      Dotenv.load
    end
  end

  task :drop => :load_db_settings do
    %x{ dropdb #{ENV['DATABASE_NAME']} }
  end

  task :create => :load_db_settings do
    %x{ createdb #{ENV['DATABASE_NAME']} }
  end

  task :migrate => :load_db_settings do
    ActiveRecord::Base.establish_connection()
    Que.connection = ActiveRecord
    Que.migrate!
    QueBus.migrate!
  end
end
