# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sendgrid_collins/version'

Gem::Specification.new do |spec|
  spec.name          = "sendgrid_collins"
  spec.version       = SendgridCollins::VERSION
  spec.authors       = ["Bradley Smith"]
  spec.email         = ["brad.smith@sendgrid.com"]
  spec.description   = %q{ API to talk to collins }
  spec.summary       = %q{ API to talk to collins }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "webmock"
  spec.add_dependency "collins_client"
end
