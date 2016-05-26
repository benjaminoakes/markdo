FROM ubuntu:16.04
MAINTAINER Benjamin Oakes

RUN apt-get update
RUN apt-get install -y ruby
# Used for building the gem
RUN apt-get install -y git

COPY . $HOME/markdo
WORKDIR $HOME/markdo/
RUN ./configure
