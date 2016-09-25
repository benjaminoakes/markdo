FROM ubuntu:16.04

RUN echo 'apt-get update && apt-get install --no-install-recommends -y "$1"' > /usr/local/bin/pkg-deb
RUN echo 'gem install --no-ri --no-rdoc "$1"' > /usr/local/bin/pkg-gem
RUN chmod +x /usr/local/bin/pkg-*

# Used for building the gem
RUN pkg-deb git

RUN pkg-deb ruby2.3
RUN pkg-deb ruby2.3-dev
RUN pkg-deb build-essential=12.1ubuntu2

RUN pkg-deb libffi-dev=3.2.1-4
RUN pkg-gem ffi:1.9.14

RUN pkg-gem bundler:1.12.5

COPY Gemfile $HOME/
COPY lib/markdo/fake_version.rb $HOME/lib/markdo/version.rb

COPY markdo.gemspec $HOME/
RUN bundle

WORKDIR /src
CMD guard
