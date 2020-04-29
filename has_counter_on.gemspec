require_relative 'lib/has_counter_on/version'

Gem::Specification.new do |spec|
  spec.name          = 'has_counter_on'
  spec.version       = HasCounterOn::VERSION
  spec.authors       = ['Injung Chung']
  spec.email         = ['mu29@yeoubi.net']

  spec.summary       = 'ActiveRecord counter_cache has been reborn, with ability to specify conditions.'
  spec.homepage      = 'https://github.com/mu29/has_counter_on'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '>= 4.1'
end
