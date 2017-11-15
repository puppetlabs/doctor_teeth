doctor_teeth
=======

# Overview
*doctor_teeth is in proof of concept development*

A Ruby Gem to contain the logic that parses the junit_xml produced by beaker and other tools into QAELK2s DB.

[![Build Status](https://travis-ci.org/puppetlabs/doctor_teeth.svg?branch=master)](https://travis-ci.org/puppetlabs/doctor_teeth)
[![Coverage Status](https://coveralls.io/repos/github/puppetlabs/doctor_teeth/badge.svg?branch=master)](https://coveralls.io/github/puppetlabs/doctor_teeth?branch=master)

# Development

* If you work at Puppet, clone this thing
  * If you don't, fork it, then clone it (if you will be contributing)
* cd $thing
* `bundle install`
* `bundle exec rake -T`

# Testing

Each PR is tested in travis at the following levels:

* yard doc coverage (we ensure decent code documentation via the `yardstick` gem
  * rake docs:verify
* rubocop static lint checking
  * rake test:rubocop
* unit tests for each class and public method
  * rake test:spec
* integration tests for the Sinatra interface
  * rake test:spec

The travis jobs are run in a docker container (see our Dockerfile).
The container image is solely for testing and is stored in Google Container Registry as a public image.
This image should be rebuilt from time to time or the bundle update which happens with each of the above testing jobs will start getting longer as gems need updating in the bundle

* remove your doctor_teeth/.bundle and Gemfile.lock
  * if your Gemfile.lock has gems in it not in the container's bundle, bundle will complain
* build the container image
  * `docker build . --tag us.gcr.io/slv-public/doctor_teeth:latest`
* make sure it works (same as in the .travis.yml file)
  * `docker run -it --volume "$(pwd)":/doctor_teeth us.gcr.io/slv-public/doctor_teeth:latest
  /bin/bash -c "bundle update; bundle exec rake test:spec"`
* push the image to GCR
  * ensure your project is set to slv-public via `gcloud init` or using command flags
  * gcloud docker -- push us.gcr.io/slv-public/doctor_teeth:latest
