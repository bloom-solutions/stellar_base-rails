$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "stellar_base/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "stellar_base"
  s.version     = StellarBase::VERSION
  s.authors     = ["Ace Subido"]
  s.email       = ["ace.subido@gmail.com"]
  s.homepage    = "https://github.com/bloom-solutions/stellar_federation-rails"
  s.summary     = "Mountable Stellar API Endpoints for Rails"
  s.description = "API Endpoints for the Stellar Protocol"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.6"
  s.add_dependency "gem_config"
  s.add_dependency "light-service"
  s.add_dependency "dry-struct"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"

end
