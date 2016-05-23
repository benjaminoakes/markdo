FROM ubuntu:latest
MAINTAINER Benjamin Oakes

RUN apt-get update
RUN apt-get install -y ruby
# Used for building the gem
RUN apt-get install -y git

WORKDIR $HOME/

COPY configure $HOME/
COPY Gemfile $HOME/
COPY markdo.gemspec $HOME/
RUN mkdir -p $HOME/lib/markdo/
COPY lib/markdo/version.rb $HOME/lib/markdo/
RUN ./configure
