# frozen_string_literal: true

require "bundler"
Bundler.setup

require_relative "support/coverage" if ENV["COVERAGE"] == "true"

require_relative "support/warnings"

Warning.process { |w| raise w } if ENV["FAIL_ON_WARNINGS"].eql?("true")

require "rom-yesql"
require "logger"

begin
  require "byebug"
rescue LoadError
end

LOGGER = Logger.new(File.open("./log/test.log", "a"))

root = Pathname(__FILE__).dirname

RSpec.configure do |config|
  config.before do
    module Test
    end
  end

  config.after do
    Object.send(:remove_const, :Test)
  end

  config.disable_monkey_patching!
  config.warnings = true
end

Dir[root.join("shared/*.rb").to_s].each { |f| require f }
