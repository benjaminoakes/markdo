FROM alpine:3.4

RUN echo 'apk update && apk add "$1"' > /usr/local/bin/pkg-apk
RUN chmod +x /usr/local/bin/pkg-*

# Used for building the gem
RUN pkg-apk git

RUN pkg-apk ruby
RUN pkg-apk ruby-bundler

COPY Gemfile $HOME/
COPY lib/markdo/fake_version.rb $HOME/lib/markdo/version.rb

COPY markdo.gemspec $HOME/
RUN bundle

WORKDIR /src
