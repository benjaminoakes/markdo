FROM ubuntu:16.04

RUN echo 'apt-get update && apt-get install --no-install-recommends -y "$1"' > /usr/local/bin/pkg-deb
RUN echo 'gem install --no-ri --no-rdoc "$1"' > /usr/local/bin/pkg-gem
RUN echo 'npm install --global "$1"' > /usr/local/bin/pkg-npm
RUN chmod +x /usr/local/bin/pkg-*

# Used for building the gem
RUN pkg-deb git=1:2.7.4-0ubuntu1

# The Ubuntu-provided `phantomjs` is quite old.  The below solution installs way more Node.js stuff than I'd like, but otherwise it's pretty painless.
RUN pkg-deb npm=3.5.2-0ubuntu4
RUN pkg-deb nodejs-legacy=4.2.6~dfsg-1ubuntu4
RUN pkg-deb libfontconfig1=2.11.94-0ubuntu1.1
RUN pkg-deb bzip2=1.0.6-8
RUN pkg-npm phantomjs-prebuilt@2.1.12

RUN pkg-deb build-essential=12.1ubuntu2
RUN pkg-deb ruby2.3
RUN pkg-deb ruby2.3-dev

RUN pkg-deb libffi-dev=3.2.1-4
RUN pkg-gem ffi:1.9.14

RUN pkg-gem bundler:1.12.5
COPY Gemfile $HOME/
COPY lib/markdo/fake_version.rb $HOME/lib/markdo/version.rb
COPY markdo.gemspec $HOME/
RUN bundle install

WORKDIR /src
CMD guard
