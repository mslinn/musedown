require_relative 'lib/musedown/version.rb'

Gem::Specification.new do |spec|
  spec.authors       = ['Erick Durán', 'Mike Slinn']
  spec.description   = <<~END_DESC
    A music notation markdown builder.
  END_DESC
  spec.email         = ['me@erickduran.com', 'mslinn@mslinn.com']
  spec.executables   = ['musedown']
  spec.files         = Dir['LICENSE.*', 'Rakefile', '{lib,spec}/**/*', '*.gemspec', '*.md']
  spec.homepage      = 'https://github.com/erickduran/musedown'
  spec.license       = 'MIT'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['changelog_uri'] = 'https://github.com/erickduran/musedown'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/erickduran/musedown'

  spec.name                  = 'musedown'
  spec.require_paths         = ['lib']
  spec.required_ruby_version   = Gem::Requirement.new('>= 3.0.0')
  spec.summary               = 'A music notation markdown builder.'
  spec.version               = Musedown::VERSION

  spec.add_dependency 'thor', '~> 0.20'
end
