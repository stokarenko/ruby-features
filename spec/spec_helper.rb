require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'bundler/setup'
Bundler.require(:default)

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
