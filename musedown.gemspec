require_relative 'lib/musedown/version'

Gem::Specification.new do |spec|
  spec.name          = "musedown"
  spec.version       = Musedown::VERSION
  spec.authors       = ["Erick Durán"]
  spec.email         = ["me@erickduran.com"]

  spec.summary       = %q{A music notation markdown builder.}
  spec.description   = %q{A music notation markdown builder.}
  spec.homepage      = "https://github.com/erickduran/musedown"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/erickduran/musedown"
  spec.metadata["changelog_uri"] = "https://github.com/erickduran/musedown"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.executables   = ["musedown"]
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 0.20"
end
