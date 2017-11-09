# frozen_string_literal: true

require 'sinatra'
require 'github/markdown'

get '/' do
  "This is the doctor_teeth ETL server, i know you are excited!<br>" +
    "We accept junit.xml files on /junit<br>" +
    "There are optional query parameters for 'project', 'configuration' and 'execution_id'<br>" +
    '<p>' +
    GitHub::Markdown.render_gfm(File.read(File.join('README.md')))
end

# test this with:
#   curl -X POST --header "Content-Type: text/xml" --data-binary @fixtures/beaker_junit_01.xml localhost:4567/junit
#   note the header is required so sinatra doesn't try to parse form params out of the data
post '/junit' do
  #project       = params['project']
  #configuration = params['configuration']
  #execution_id  = params['execution_id']

  request.body.rewind  # in case someone already read it
  datablob = request.body.read

  #DoctorTeeth.parse(datablob,
                    #{:configuration => configuration,
                     #:project => project,
                     #:execution_id => execution_id})
  DoctorTeeth.parse(datablob,
                    {:configuration => {}})


end

# the whole shebang
module DoctorTeeth
  require 'doctor_teeth/parser'
  require 'doctor_teeth/json_parser'

  # method stub for parsing
  # @param xml [String] junit xml test_run data
  # @param opts [Hash] the options containing extra metadata not in junit.xml
  # @return test_run
  # @api public
  # @example
  #   DoctorTeeth.parse(<xml blah>, {:configuration => {}})
  def self.parse(xml, opts)
    DoctorTeeth::Parser.new(xml, opts).test_run
  end

  # method stub for parsing json
  # @param json [String] path of json file(s) containing indexed test_run data
  # @return test_run
  # @api public
  # @example
  #   DoctorTeeth.parse_json_file('some_json.json')
  def self.parse_json_file(json)
    # @todo: make file????
    DoctorTeeth::NewLineJsonFileParser.new(json)
  end
end
