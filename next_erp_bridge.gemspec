# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'next_erp_bridge/version'

Gem::Specification.new do |spec|
  spec.name          = "next_erp_bridge"
  spec.version       = NextErpBridge::VERSION
  spec.authors       = ["abhisheksarka"]
  spec.email         = ["abhisheksarka@gmail.com"]

  spec.summary       = %q{CRUD API for NextErp Doctypes}
  spec.description   = %q{Provides CRUD operations for all default/custom Doctypes in NextErp}
  spec.homepage      = "https://github.com/NestAway/next_erp_bridge/"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
  
  spec.add_dependency 'activesupport', "< 5.0"
  spec.add_dependency 'httparty'
end
