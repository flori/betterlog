if ENV['START_SIMPLECOV'].to_i == 1
  require 'simplecov'
  SimpleCov.start do
    add_filter "#{File.basename(File.dirname(__FILE__))}/"
  end
end
require 'rspec'
begin
  require 'byebug'
rescue LoadError
end
require 'mock_redis'
class MockRedis
  class BaseConnectionError < StandardError; end
  class CannotConnectError < BaseConnectionError; end
end
Redis=MockRedis
require 'betterlog'
Betterlog::Log.default_logger = Logger.new(nil)
