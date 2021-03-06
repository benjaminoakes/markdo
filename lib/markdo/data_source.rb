module Markdo
  class DataSource
    def self.http_get(url)
      Promise.new.tap do |promise|
        cache_breaker = Time.now.to_i
        url_with_cache_breaker = [url, cache_breaker].join('?')

        HTTP.get(url_with_cache_breaker) do |response|
          if 200 == response.status_code
            promise.resolve(response)
          else
            promise.reject(response)
          end
        end
      end
    end

    def initialize(env)
      @env = env
    end

    def lines_from_all
      Dir.
        glob("#{@env['MARKDO_ROOT']}/*.md").
        sort.
        map { |path| File.readlines(path, encoding: 'UTF-8') }.
        flatten
    end

    def lines_from_inbox
      File.readlines(inbox_path, encoding: 'UTF-8')
    end

    def inbox_path
      file_path(@env['MARKDO_INBOX'])
    end

    def file_path(filename)
      File.join(@env['MARKDO_ROOT'], filename)
    end
  end
end
