# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'method_logger'

Gem::Specification.new do |spec|
  spec.name          = "method_logger"
  spec.version       = MethodLogger::VERSION
  spec.authors       = ["Liss McCabe"]
  spec.email         = ["liss@eristiccode.com"]

  spec.summary       = %q{Logs calls to a specified method.}
  spec.description   = %q{My solution to tkrajcar's Ruby Metaprogramming
  challenge at https://gist.github.com/tkrajcar/fd1e3aee770d5d940947}
  spec.homepage      = "https://github.com/dysnomian/method_logger"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
