require 'nokogiri'
module DoctorTeeth
  class NewLineJsonFileParser

    attr_accessor :test_runs

    def initialize(file)

      json_files = []
      @test_runs = {}

      if File.directory?(file)
        json_files = Dir.entries(file)
        json_files.delete_if{ |file| file.chars.first == '.' }
        json_files.map!{ |f| File.join(file, f) }

      else
        json_files.push(File.expand_path(file))
      end

      file_count = json_files.length
      puts "Attempting to process #{file_count} json files"
      json_files.each do |json|

        (file_count % 50 == 0) ? output_char = ".\n" : output_char = '.'
        print output_char

        File.open(json).each do |line|

          begin
          json_object = JSON.parse(line)
          # translate elasticsearch record to QALEK2 schema
          test_record = {
              'execution_id'    => json_object['_source']['jenkins_build_url'],
              #TODO need to find a better way to translate project name
              'project'         => json_object['_source']['job_name'],
              #'duration'        => json_object['_source'][],
              'configuration'   => json_object['_source']['configs'],
              'start_time'      => Time.parse(json_object['_source']['start_time']).utc,
              'suite_name'      => json_object['_source']['test_case_suite'],

              # need to look up which suite this is
              'suite_duration'  => json_object['_source']["#{json_object['_source']['test_case_suite']}_time"],
              'test_name'       => json_object['_source']['test_case_name'],
              'test_status'     => json_object['_source']['test_case_status'],
              'test_duration'   => json_object['_source']['test_case_time'],
          }

          #add up test_run duration, values could be nil
          suite_durations = [json_object['_source']['pre_suite_time'], json_object['_source']['tests_time']].compact
          test_record['duration'] = suite_durations.inject(:+)
          insert_record(test_record)

          rescue Exception => e
            puts "OHH NO!!!!! Skipping a record \n #{e}"

          end
        end

        file_count += -1
      end
    end


    def insert_record(test_record={})
      id            = test_record['execution_id']
      project       = test_record['project']
      duration      = test_record['duration']
      configuration = test_record['configuration']
      start_time    = test_record['start_time']

      # suite properties
      suite_name    = test_record['suite_name']
      suite_duration= test_record['suite_duration']

      #test cae properties
      test_name     = test_record['test_name']
      test_status   = test_record['test_status']
      test_duration = test_record['test_duration']


      # set keys conditionally one at a time
      @test_runs[id]                  ||= {'execution_id' => id}
      @test_runs[id]['project']       ||= project
      @test_runs[id]['duration']      ||= duration
      @test_runs[id]['configuration'] ||= configuration
      @test_runs[id]['start_time']    ||= start_time
      @test_runs[id]['test_suites']   ||= []

      test_case = {'name' => test_name, 'duration' => test_duration, 'status' => test_status}
      test_suite = {'name' => suite_name, 'duration' => suite_duration, 'test_cases' => [test_case]}

      if @test_runs[id]['test_suites'].empty?

        # create the first
        @test_runs[id]['test_suites'].push(test_suite)
      else

        # does suite exist?
        if @test_runs[id]['test_suites'].any?{ |suite| suite['name'] == suite_name}

          @test_runs[id]['test_suites'].each do |suite|
            next unless suite['name'] == suite_name
            #create empty test_cases array if it does not exist
            suite['test_cases']||= []
            #check if this is a duplicate record (there should not be duplicate records)
            raise 'CRAP! DUPLICATE RECORD!' if suite['test_cases'].any?{ |test| test == test_name}
            #add test case
            suite['test_cases'].push(test_case)
          end
        else

          #create the suite with test_case inside
          @test_runs[id]['test_suites'].push(test_suite)
        end
      end
    end

    def generate_new_line_delimited_json_file(file)

      line_count = @test_runs.length
      puts "\nAttempting to write #{line_count} json objects to #{file}"
      File.open(file, 'w') do |f|

        @test_runs.each do |k,v|

          (line_count % 50 == 0) ? output_char = ".\n" : output_char = '.'
          print output_char

          f.write(JSON.generate({'test_run' => v}))
          f.write("\n")

          line_count += -1
        end
      end
    end
  end
end