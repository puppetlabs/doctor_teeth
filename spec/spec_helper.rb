# frozen_string_literal: true

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/'
    add_filter '.bundle/gems'
  end
end

require 'rspec'
require 'doctor_teeth'

def random_string
  (0...10).map { ('a'..'z').to_a[rand(26)] }.join
end
