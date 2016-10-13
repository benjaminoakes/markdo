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

  it 'renders loaded Markdown content for each filter' do
    example_tasks = [
      '- [x] Complete @star',
      '- [ ] Incomplete and starred @star',
      '- [ ] Work in Progress @wip',
      '- [ ] Deferred @defer(2016-10-01)',
      '- [ ] Clearly overdue @due(2016-01-01)',
      '- [ ] Want to do soon @next',
      '- [ ] @waiting Receive something from @someone',
    ]

    example_tasks << [-1, 0, 1, 2].map { |date_offset|
      adjusted_date = Date.today + date_offset
      "- [ ] Due on date @due(#{adjusted_date.iso8601})"
    }

    example_markdown = example_tasks.flatten.join("\n")
    File.write('/src/docs/data/__all__.md', example_markdown)

    visit '/index.html'
    filter_links = all('#rb-filter-nav a')

    expect(filter_links.count).not_to be_zero

    all('#rb-filter-nav a').each do |filter_link|
      expect(filter_link.find('.badge').text).to match(/^\d+$/)
      click_on(filter_link.text)
      expect(find('#rb-markdown-document').text).not_to be_empty
    end
  end
end
