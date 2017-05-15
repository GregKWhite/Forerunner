$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "forerunner/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "forerunner"
  s.version     = Forerunner::VERSION
  s.authors     = ["Greg White"]
  s.email       = ["gkwhite95@gmail.com"]
  s.summary     = "Forerunner #{Forerunner::VERSION}"
  s.description = "Run before_actions in a more intuitive way."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.2"
  s.add_development_dependency "rspec"
  s.add_development_dependency "pry"
  s.add_development_dependency "rubocop"
end
