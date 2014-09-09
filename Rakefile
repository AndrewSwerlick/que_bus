#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rake/testtask'


namespace :test do
  Rake::TestTask.new(:sync) do |t|
    t.libs << 'lib/que_bus'
    t.test_files = FileList['spec/lib/que_bus/*_spec.rb'].exclude('spec/lib/que_bus/async_*_spec.rb')
  end

  Rake::TestTask.new(:async) do |t|
    t.test_files = FileList['spec/lib/que_bus/async_*_spec.rb']
  end

  task :default => :sync
end

task :irb do
  require_relative 'spec/interactive_helper'
  require 'irb'
  ARGV.clear
  Que.mode = :async
  IRB.start
end

task :default => "test:default"
