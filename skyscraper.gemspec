# -*- encoding: utf-8 -*-
require File.expand_path('../lib/./version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Adam Dratwinski"]
  gem.email         = ["arboooz@gmail.com"]
  gem.description   = %q{Library that helps scraping data from websites in easy way}
  gem.summary       = %q{Library that helps scraping data from websites in easy way}
  gem.homepage      = "https://github.com/boooz/skyscraper"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.name          = "Skyscraper"
  gem.require_paths = ["lib"]
  gem.version       = Skyscraper::VERSION

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rake"
  gem.add_dependency "nokogiri"
  gem.add_dependency "actionpack"
end
