# -*- encoding: utf-8 -*-
require File.expand_path('../lib/skyscraper/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Adam Dratwinski"]
  gem.email         = ["arboooz@gmail.com"]
  gem.summary       = %q{Easy to use DSL that helps scraping data from websites}
  gem.description   = %q{Easy to use DSL that helps scraping data from websites. Thanks to it, writing web crawlers would be very fast and intuitive. Traversing through html nodes and fetching all of the HTML attributes, would be possible. Just like in jQuery - you will find methods like parent, children, first, find, siblings etc. Furthermore, you are able to download images, web pages, and store all content in the database. Please visit my Github account for more details.}
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
