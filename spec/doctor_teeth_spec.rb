# frozen_string_literal: true

require 'spec_helper'

describe Sinatra do
  it "should allow accessing the home page" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to match(/doctor_teeth ETL server/)
    expect(last_response.body).to match(/parses the junit_xml/)
  end

  it 'should take empty junit, produce valid json' do
    post '/junit', params=''
    expect(last_response).to be_ok
    # FIXME: this probably isn't valid json
    expect(last_response.body).to eq("[\"test_run\", {\"project\"=>nil, \"duration\"=>0.0, \"configuration\"=>[], \"start_time\"=>nil, \"execution_id\"=>nil, \"test_suites\"=>[]}]")
  end

  # FIXME: json parse this (once it's valid json), check params
  # FIXME: do this with the extra meta data too
  it 'should take good junit, produce good json' do
    header 'Content-Type', 'text/xml'
    post '/junit', params=File.read('spec/fixtures/beaker_junit_03.xml')
    expect(last_response).to be_ok
    expect(last_response.body).to match(/\"start_time\"=>2016-08-01 23:09:46 UTC/)
    expect(last_response.body).to match(/running tests on local machine/)
  end
end
