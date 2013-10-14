require 'rubygems'
require 'minitest/autorun'
require 'minitest/reporters'
require 'vcr'

# Better reporters
Minitest::Reporters.use! #for status bar
# Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new #for understanding
# Minitest::Reporters.use! Minitest::Reporters::RubyMineReporter.new #for IDE

DUMMY_API_KEY = 'DUMMY_API_KEY'
BIBLESEARCH_API_KEY = ENV.fetch('BIBLESEARCH_API_KEY', DUMMY_API_KEY)
API_KEY_TEMPLATE='<%= api_key %>'
CASSETTE_VARS = {api_key: BIBLESEARCH_API_KEY}
VCR_LOG_FILE='VCR.LOG'

VCR.configure do |c|
  # BASIC CONFIGURATION
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.debug_logger = File.open(VCR_LOG_FILE, 'w')

  # DISABLE RECORDING UNLESS THERE'S API KEY IN THE ENV
  if BIBLESEARCH_API_KEY == DUMMY_API_KEY
    # don't record
    c.default_cassette_options = {:record => :none}
  else
    # we have an API key, might want to record
    c.default_cassette_options = {:record => :new_episodes}
  end

  #EXPUNGE SECRET KEYS
  #  when recording, transform secrets to a template
  c.filter_sensitive_data( API_KEY_TEMPLATE) { BIBLESEARCH_API_KEY }
  #  when playing, transform template into secrets
  c.default_cassette_options[:erb] = CASSETTE_VARS
end

#Development help for minitest
module Kernel
    # completely skip a describe block
    def xdescribe desc, additional_desc = nil, &block
        puts "Skipping xdescribe(#{desc})"
        # raise MiniTest::Skip, "Skipping with xdescribe", desc
    end
end

$LOAD_PATH.unshift File.join('.', 'lib')
