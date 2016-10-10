require 'spec_helper'
require 'markdo/markdown_renderer'

module Markdo
  describe MarkdownRenderer do
    describe 'converting Markdown to HTML' do
      it 'renders an empty string to an empty string' do
        renderer = MarkdownRenderer.new('')
        expect(renderer.to_html).to eq('')
      end

      it 'delegates rendering simple formatting' do
        renderer = MarkdownRenderer.new("## Heading 2\n\n* List item with **bold text**\n")

        expect(renderer.to_html.strip).to eq(<<-HTML.strip)
<h2>Heading 2</h2>

<ul>
<li>List item with <strong>bold text</strong></li>
</ul>
        HTML
      end

      it 'renders checkboxes' do
        renderer = MarkdownRenderer.new("- [x] Complete\n- [ ] Incomplete")

        expect(renderer.to_html.strip).to eq(<<-HTML.strip)
<p><input checked disabled type=checkbox> Complete<br>
<input disabled type=checkbox> Incomplete<br></p>
        HTML
      end
    end
  end
end
