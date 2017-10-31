doctor_teeth
=======

# Overview
*doctor_teeth is in proof of concept development*

A Ruby Gem to contain the logic that parses the junit_xml produced by beaker and other tools into QAELK2s DB.

[![Build Status](https://travis-ci.org/puppetlabs/doctor_teeth.svg?branch=master)](https://travis-ci.org/puppetlabs/doctor_teeth)
[![Coverage Status](https://coveralls.io/repos/github/puppetlabs/doctor_teeth/badge.svg?branch=master)](https://coveralls.io/github/puppetlabs/doctor_teeth?branch=master)

# Example
```ruby

require 'doctor_teeth'
require 'json'

path = File.join('path', 'to', 'beaker_junit.xml')

# example test run metadata
opts = {
        :project        => 'PE-Console UI',
        :duration       => 198347,
        :start_time     => Time.now.getutc,
        :execution_id   => (0...25).map { ('a'..'z').to_a[rand(26)] }.join,
        :configuration  => 'THIS IS THE CONFIGURATION'
    }

hash = DoctorTeeth.parse(path, opts)

hash.to_json

```
