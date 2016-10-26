module Markdo
  class Config
    def self.fetch
      Promise.new.tap do |promise|
        BrowserDataSource.get('data/config.json').then do |response|
          config = new
          config.tags = response.json['tags']
          promise.resolve(config)
        end
      end
    end

    attr_accessor :tags
  end
end
