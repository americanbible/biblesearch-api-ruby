# -*- encoding: utf-8 -*-
require File.expand_path('../lib/biblesearch-api/client_version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Bryce Allison"]
  gem.email         = ["support@bibles.org"]
  gem.description   = %q{Wrapper for the American Bible Society Bible Search API}
  gem.summary       = %q{Wrapper for the American Bible Society Bible Search API}
  gem.homepage      = "http://bibles.org"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "biblesearch-api"
  gem.require_paths = ["lib"]
  gem.version       = BibleSearch::VERSION

  gem.add_dependency "oj"
  gem.add_dependency "hashie", "= 2.0.5"
  gem.add_dependency "httparty"
  gem.add_development_dependency 'vcr', '= 2.6.0'
  gem.add_development_dependency 'webmock' , '>= 1.8.0', '< 1.14'
  gem.add_development_dependency 'minitest', '= 3.3.0'
  gem.add_development_dependency 'rake', '= 0.9.2.2'
  gem.add_development_dependency 'minitest-reporters', '>= 0.5.0'
  gem.add_development_dependency 'guard-minitest'
end
