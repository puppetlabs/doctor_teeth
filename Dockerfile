FROM centos:7
MAINTAINER Eric Thompson <erict@puppet.com>

RUN yum -y update && yum -y install git ruby ruby-devel make gcc gcc-c++ zlib-devel && yum clean all
# skip installing gem documentation
RUN echo 'gem: --no-rdoc --no-ri' >> "$HOME/.gemrc"
RUN gem install bundler

RUN git clone https://github.com/puppetlabs/doctor_teeth.git
WORKDIR doctor_teeth

RUN bundle install
