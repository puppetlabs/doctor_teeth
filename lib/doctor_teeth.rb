# frozen_string_literal: true

# the whole shebang
module DoctorTeeth
  require 'doctor_teeth/parser'
  require 'doctor_teeth/json_parser'

  # method stub for parsing
  # @param [String] path of junit xml file(s) of test_run data
  # @param [Hash] opts the options containing extra metadata not in junit.xml
  # @return test_run
  def self.parse(xml, opts)
    DoctorTeeth::Parser.new(xml, opts).test_run
  end

  # method stub for parsing json
  # @param [String] path of json file(s) containing indexed test_run data
  # @return test_run
  def self.parse_json_file(json)
    # @todo: make file????
    DoctorTeeth::NewLineJsonFileParser.new(json)
  end
end
