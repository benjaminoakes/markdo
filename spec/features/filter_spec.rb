require 'fileutils'

describe 'the task filters', type: :feature do
  before do
    if RUBY_ENGINE == 'opal'
      skip 'Capybara is not supported in Opal'
    else
      require 'capybara/rspec'
      require 'capybara/poltergeist'
      Capybara.default_driver = :poltergeist
      Capybara.app = Rack::Directory.new('./docs')
    end
  end

  it 'shows help text on first load' do
    visit '/index.html'
    expect(page).to have_content 'Markdo'
  end

  it 'renders loaded Markdown content' do
    FileUtils.mkdir_p('/src/docs/data/')
    File.write('/src/docs/data/__all__.md', '- [ ] Success')
    visit '/index.html'
    click_on 'All'
    expect(page).to have_content 'Success'
  end
end
