# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rapel/version'

Gem::Specification.new do |spec|
  spec.name          = "rapel"
  spec.version       = Rapel::VERSION
  spec.authors       = ["Dominic Muller"]
  spec.email         = ["nicklink483@gmail.com"]

  spec.summary       = %q{Multi-client, multi-runtime REPL Server}
  spec.description   = %q{Rapel (ruh-PELL) provides a multi-client, multi-runtime REPL server which accepts incoming expressions, e.g. 2+2, evaluates them in a runtime, and returns the result, e.g. 4.}
  spec.homepage      = "https://github.com/domgetter/rapel"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
