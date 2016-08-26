lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby-features/version'

Gem::Specification.new do |s|
  s.name        = 'ruby-features'
  s.version     = RubyFeatures::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.authors     = 'Sergey Tokarenko'
  s.email       = 'private.tokarenko.sergey@gmail.com'
  s.homepage    = 'https://github.com/stokarenko/ruby-features'
  s.summary     = 'Makes extending of Ruby classes and modules to be easy, safe and controlled.'
  s.description = s.summary
  s.license     = 'MIT'

  s.files       = Dir['{lib}/**/*', 'LICENSE', 'README.md']
  s.test_files  = Dir['{spec}/**/*']

  s.required_ruby_version = '>= 2.0.0'

  s.add_development_dependency 'bundler'
end
