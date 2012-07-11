# -*- encoding: utf-8 -*-
require File.expand_path('../lib/well_rested-core/version', __FILE__)

Gem::Specification.new do |gem|

  gem.add_runtime_dependency 'well_rested', '~> 0.6'

  gem.authors       = ["Christian Rohrer"]
  gem.email         = ["hydrat@gmail.com"]
  gem.description   = %q{A fork of the well_rested gem with adaption for the SWITCHtoolbox Core API}
  gem.summary       = %q{A fork of the well_rested gem with adaption for the SWITCHtoolbox Core API}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "well_rested-core"
  gem.require_paths = ["lib"]
  gem.version       = WellRested::Core::VERSION
end
