# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "pry"
require "vcr"
require "rspec/rails"
require "stellar-sdk"
require "rspec-sidekiq"
require "virtus/matchers/rspec"
require "stellar_spectrum"
require "dotenv"

SPEC_DIR = Pathname.new(File.dirname(__FILE__))
ROOT_DIR = SPEC_DIR.join("..")
FIXTURES_DIR = SPEC_DIR.join("fixtures")

Dotenv.load(".env.local", ".env")
# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[StellarBase::Engine.root.join("spec/support/**/*.rb")].each do |f|
  require f
end

RSpec.configure do |config|
  config.use_transactional_fixtures = true
end
