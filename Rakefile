#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib/que_bus'
  t.test_files = FileList['spec/lib/que_bus/*_spec.rb']
end

task :irb do
  require_relative 'spec/interactive_helper'
  require 'irb'
  ARGV.clear
  Que.mode = :async
  IRB.start
end

task :default => :test
