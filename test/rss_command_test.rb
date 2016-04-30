require 'test_helper'
require 'markdo/rss_command'

module Markdo
  describe RssCommand do
    it 'outputs RSS from the input Markdown' do
      out = StringIO.new
      err = StringIO.new
      env = { 'MARKDO_ROOT' => 'test/fixtures' }

      RssCommand.new(out, err, env).run

      puts out.string

      out.string.must_equal <<-XML
<?xml version="1.0" encoding="UTF-8"?>
        <rss version="2.0">
          <channel>
            <title>Links in Markdo</title>
          <item>
            <title>Task with HTTP URL http://www.example.com/</title>
            <link>http://www.example.com/</link>
          </item>
          <item>
            <title>Task with HTTPS URL https://www.example.com/</title>
            <link>https://www.example.com/</link>
          </item>
          <item>
            <title>Task with HTTP URL http://www.example.com/ and trailing text</title>
            <link>http://www.example.com/</link>
          </item>
          </channel>
        </rss>
      XML
    end
  end
end
