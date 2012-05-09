# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rest_resource/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tim Payton"]
  gem.email         = ["timpayton@gmail.com"]
  gem.description   = %q{Simplifies consumption of restful APIs, including a query interface like ActiveRecord. }
  gem.summary       = %q{Simplifies consumption of restful APIs, including a query interface like ActiveRecord. }
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rest_resource"
  gem.require_paths = ["lib"]
  gem.version       = RestResource::VERSION

  gem.add_development_dependency('minitest', '>= 3.0.0')
end