# frozen_string_literal: true

require_relative "lib/digitalhumani/version"

Gem::Specification.new do |spec|
  spec.name          = "digitalhumani"
  spec.version       = DigitalHumani::VERSION
  spec.authors       = ["Carl Scheller"]
  spec.email         = ["carl@digitalhumani.com"]

  spec.summary       = "The official Ruby SDK for DigitalHumani's RaaS (Reforestation-as-a-Service)"
  spec.homepage      = "https://digitalhumani.com"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/digitalhumani/ruby-sdk"
  spec.metadata["changelog_uri"] = "https://github.com/digitalhumani/ruby-sdk/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Dependencies
  spec.add_dependency "faraday", "~> 1.7.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.14"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
