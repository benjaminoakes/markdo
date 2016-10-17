if RUBY_ENGINE != 'opal'
  require 'capybara/rspec'
  require 'capybara/poltergeist'
  Capybara.default_driver = :poltergeist
  Capybara.app = Rack::Directory.new('./docs')
end
