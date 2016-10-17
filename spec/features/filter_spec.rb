require 'fileutils'
require 'feature_spec_helper'

describe 'the task filters', type: :feature do
  before do
    skip 'Capybara is not supported' if !defined?(Capybara)
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
      '- [ ] Pick up something @downtown',
      '- [ ] Buy something @shopping',
    ]

    example_tasks << [-1, 0, 1, 2].map { |date_offset|
      adjusted_date = Date.today + date_offset
      "- [ ] Due on date @due(#{adjusted_date.iso8601})"
    }

    example_markdown = example_tasks.flatten.join("\n")
    FileUtils.mkdir_p('/src/docs/data/')
    File.write('/src/docs/data/__all__.md', example_markdown)
    File.write('/src/docs/data/config.json', '{"tags":["Downtown","Shopping","Someone"]}')

    visit '/index.html'
    filter_links = all('#rb-filter-nav a')

    expect(filter_links.count).not_to be_zero

    click_on('Overview')

    all('#rb-filter-nav a').each do |filter_link|
      expect(filter_link.find('.badge').text).to match(/^\d+$/)
      click_on(filter_link.text)
      expect(find('#rb-markdown-document').text).not_to be_empty
    end

    click_on('Tags')

    all('#rb-tag-nav a').each do |filter_link|
      expect(filter_link.find('.badge').text).to match(/^\d+$/)
      click_on(filter_link.text)
      expect(find('#rb-markdown-document').text).not_to be_empty
    end
  end
end
