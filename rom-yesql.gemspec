lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rom/yesql/version'

Gem::Specification.new do |spec|
  spec.name          = "rom-yesql"
  spec.version       = ROM::Yesql::VERSION.dup
  spec.authors       = ["Piotr Solnica"]
  spec.email         = ["piotr.solnica@gmail.com"]
  spec.summary       = 'Yesql adapter for ROM'
  spec.description   = spec.summary
  spec.homepage      = "http://rom-rb.org"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rom", "~>5"
  spec.add_runtime_dependency "dry-core", "~>1.0"
  spec.add_runtime_dependency "sequel", "~>5"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
end
