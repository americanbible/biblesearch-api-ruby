require 'rubygems'
require 'bundler'
Bundler::GemHelper.install_tasks
require "bundler/gem_tasks"
require 'rake/testtask'

# one way to remove cassette files
# require 'rake/clean'
# CLOBBER.include('spec/cassettes/*.yaml')

RUBY_TEST_VERSIONS = [
  '1.8.7',
  '1.9.2-p180',
  '1.9.3'
]

namespace "test" do

  desc 'Run all of the gem minitests.'
  Rake::TestTask.new(:all) do |t|
    t.libs.push "spec"
    t.pattern = 'spec/**/*_spec.rb'
    t.verbose = true
  end

  desc 'Focus on a particular test file (hardcoded for now).'
  Rake::TestTask.new(:focus) do |t|
    t.libs.push "spec"
    t.pattern = 'spec/**/fumsify*_spec.rb'
    t.verbose = true
  end

  desc 'Tests the library against several rubies'
  task :overtest do
    system "rvm #{RUBY_TEST_VERSIONS.map{|x| "#{x}@biblesearch-api"}.join(',')} do bundle exec rake test"
  end


end

task :default => "test:all"

