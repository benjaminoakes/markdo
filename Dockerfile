FROM ubuntu:16.04
MAINTAINER Benjamin Oakes

RUN apt-get update
# Used for building the gem
RUN apt-get install -y git

RUN apt-get install -y ruby
RUN gem install --no-ri --no-rdoc bundler

COPY Gemfile $HOME/
COPY lib/markdo/fake_version.rb $HOME/lib/markdo/version.rb

COPY markdo.gemspec $HOME/
RUN bundle
