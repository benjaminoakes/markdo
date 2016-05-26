FROM ubuntu:16.04
MAINTAINER Benjamin Oakes

RUN apt-get update
# Used for building the gem
RUN apt-get install -y git

RUN apt-get install -y ruby
RUN gem install --no-ri --no-rdoc bundler

COPY Gemfile $HOME/
RUN mkdir -p $HOME/lib/markdo/
COPY lib/markdo/version.rb $HOME/lib/markdo/

COPY markdo.gemspec $HOME/
RUN bundle
