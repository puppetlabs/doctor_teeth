# coding: utf-8
# frozen_string_literal: true

# place ONLY runtime dependencies in here (in addition to metadata)
require File.expand_path('../lib/doctor_teeth/version', __FILE__)

Gem::Specification.new do |s|
  s.name          = 'doctor_teeth'
  s.authors       = ['Puppet, Inc.', 'Zach Reichert', 'Eric Thompson']
  s.email         = ['qa@puppet.com']
  s.summary       = 'Logic to parse junit_xml into a schema we use in BigQuery'
  s.homepage      = 'https://github.com/puppetlabs/doctor_teeth'
  s.version       = DoctorTeeth::Version::STRING
  s.files         = Dir['CONTRIBUTING.md', 'LICENSE.md', 'MAINTAINERS',
                        'README.md', 'lib/**/*']
  s.required_ruby_version = '>= 2.0.0'

  # Run time dependencies
  s.add_runtime_dependency 'nokogiri', '~> 1.8.0'
  s.add_runtime_dependency 'sinatra',  '~> 2.0.0'
  s.add_runtime_dependency 'thin',     '~> 1.7.0'
  s.add_runtime_dependency 'github-markdown'
end
