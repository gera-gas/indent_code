# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'indent_code/version'

Gem::Specification.new do |spec|
  spec.name          = "indent_code"
  spec.version       = IndentCode::VERSION
  spec.authors       = ["Anton S. Gerasimov"]
  spec.email         = ["gera_box@mail.ru"]
  spec.summary       = %q{This utilities with CLI (Command Line Interface) for normalize indentation in your source code. This gem use the 'iparser' gem as a parser engine.}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/gera-gas/indent_code"
  spec.license       = "MIT"
  spec.files         = ["lib/indent_code.rb", "lib/indent_code/application.rb", "lib/indent_code/cleaner.rb", "lib/indent_code/indent_cpp.rb", "lib/indent_code/version.rb"]
  spec.bindir        = "bin"
  spec.executables   = "indent"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "iparser", "~> 1.1.7"
end
