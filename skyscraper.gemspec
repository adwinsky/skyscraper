# -*- encoding: utf-8 -*-
require File.expand_path('../lib/skyscraper/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Adam Dratwinski"]
  gem.email         = ["arboooz@gmail.com"]
  gem.summary       = %q{Library that helps scraping data from websites in easy way}
  gem.description   = %q{Library that helps scraping data from websites in easy way. Skyscraper allows you to traversing through html nodes, similary to jquery, it provides methods like parent, children, first, find, siblings etc. Thanks to Skyscraper you can fetch all HTML attributes on any node. Furthermore it's allow to download images, webpages, and store content in the database. Please visit Github account for more details.}
  gem.homepage      = "https://github.com/boooz/skyscraper"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.name          = "skyscraper"
  gem.require_paths = ["lib"]
  gem.version       = Skyscraper::VERSION

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rake"
  gem.add_dependency "nokogiri"
  gem.add_dependency "actionpack"
end
