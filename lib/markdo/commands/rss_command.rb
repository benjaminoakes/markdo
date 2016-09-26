require 'markdo/command'
require 'uri'

module Markdo
  class RssCommand < Command
    def run
      uri_parser = URI::Parser.new

      items = Dir.
        glob(markdown_glob).
        map { |path| File.readlines(path, encoding: 'UTF-8') }.
        flatten.
        grep(%r(https?://)).
        map { |line| Item.new(title: clean(line), links: uri_parser.extract(line)) }

      xml = template(items)

      @stdout.puts(xml)
    end

    protected

    class Item
      attr_reader :title, :links

      def initialize(kwargs)
        @title = kwargs[:title]
        @links = kwargs[:links]
      end

      def link
        links && !links.empty? && links[0]
      end
    end

    def markdown_glob
      "#{@env['MARKDO_ROOT']}/*.md"
    end

    def clean(line)
      line.sub(/\s*[-*] \[.\]\s+/, '').chomp
    end

    def template(items)
      buf = []

      # No beginning of line whitespace allowed
      buf << %(<?xml version="1.0" encoding="UTF-8"?>)

      buf << %(<rss version="2.0">)
      buf << %(<channel>)
      buf << %(<title>Links in Markdo</title>)

      items.each do |item|
        buf << %(<item>)
        buf << %(<title>#{item.title}</title>)
        buf << %(<link>#{item.link}</link>)
        buf << %(</item>)
      end

      buf << %(</channel>)
      buf << %(</rss>)

      buf.join("\n")
    end
  end
end
