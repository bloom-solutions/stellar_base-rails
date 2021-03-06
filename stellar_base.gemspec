$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "stellar_base/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "stellar_base-rails"
  s.version     = StellarBase::VERSION
  s.authors     = ["Ace Subido"]
  s.email       = ["ace.subido@gmail.com"]
  s.homepage    = "https://github.com/bloom-solutions/stellar_base-rails"
  s.summary     = "Mountable Stellar API Endpoints for Rails"
  s.description = "API Endpoints for the Stellar Protocol"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "disposable"
  s.add_dependency "dry-types"
  s.add_dependency "gem_config"
  s.add_dependency "httparty"
  s.add_dependency "light-service"
  s.add_dependency "multi_json" # required by representable json
  s.add_dependency "addressable"
  s.add_dependency "sidekiq", ">= 5.0"
  s.add_dependency "rails", "~> 6.0"
  s.add_dependency "representable"
  s.add_dependency "stellar-base", ">= 0.18.0"
  s.add_dependency "storext", "~> 3.0"
  s.add_dependency "toml-rb", "~> 1.0"
  s.add_dependency "trailblazer", ">= 2.0", "< 2.1"
  s.add_dependency "trailblazer-rails"
  s.add_dependency "reform-rails"
  s.add_dependency "virtus"

  s.add_development_dependency "dotenv", "~> 2.5"
  s.add_development_dependency "factory_bot_rails"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "rspec-sidekiq"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "stellar-sdk", ">= 0.6.0"
  s.add_development_dependency "stellar_spectrum", "~> 1.0"
  s.add_development_dependency "vcr", "~> 4.0"
  s.add_development_dependency "virtus-matchers", "0.4.0"
  s.add_development_dependency "webmock"
end
