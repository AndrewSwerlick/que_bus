#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib/bramipsum'
  t.test_files = FileList['spec/lib/que_bus/*_spec.rb']
  t.verbose = true
end

task :default => :test
