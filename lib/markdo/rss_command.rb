require 'markdo/command'
require 'uri'

module Markdo
  class RssCommand < Command
    def run
      items = Dir.
        glob(markdown_glob).
        map { |path| File.readlines(path, encoding: 'UTF-8') }.
        flatten.
        grep(%r(https?://)).
        map { |line| Item.new(title: clean(line), links: URI.extract(line)) }

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
      # No beginning of line whitespace allowed
      buf = '<?xml version="1.0" encoding="UTF-8"?>'

      buf = <<-XML
        <rss version="2.0">
          <channel>
            <title>Links in Markdo</title>
      XML

      items.each do |item|
        buf << <<-XML
          <item>
            <title>#{item.title}</title>
            <link>#{item.link}</link>
          </item>
        XML
      end

      buf << <<-XML
          </channel>
        </rss>
      XML

      buf
    end
  end
end
