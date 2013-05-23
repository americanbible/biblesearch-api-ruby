require 'rubygems'
require 'minitest/autorun'

require 'vcr'

VCR.configure do |c|
  #c.default_cassette_options = {:record => :new_episodes}
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
end

$:.unshift File.join('.', 'lib')
