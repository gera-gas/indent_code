# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'indent_code/version'

Gem::Specification.new do |spec|
  spec.name          = "indent_code"
  spec.version       = IndentCode::VERSION
  spec.authors       = ["anton"]
  spec.email         = ["gera_box@mail.ru"]

  spec.summary       = %q{This utilities with CLI (Command Line Interface) for normalize indentation in your source code.}
  spec.description   = %q{This gem use the 'iparser'gem as a parser engine. For details gem, use '--help' option.}
  spec.homepage      = "https://github.com/gera-gas/indent_code"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = "indent"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "iparser", "~> 1.1.6"
end
