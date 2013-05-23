require 'rubygems'
require 'bundler'
Bundler::GemHelper.install_tasks
require "bundler/gem_tasks"
require 'rake/testtask'

RUBY_TEST_VERSIONS = [
  '1.8.7',
  '1.9.2-p180',
  '1.9.3'
]

Rake::TestTask.new do |t|
  t.libs.push "spec"
  t.pattern = 'spec/**/*_spec.rb'
  t.verbose = true
end

task :default => :test

desc 'Tests the library against several rubies'
task :overtest do
  system "rvm #{RUBY_TEST_VERSIONS.map{|x| "#{x}@biblesearch-api"}.join(',')} do bundle exec rake test"
end
