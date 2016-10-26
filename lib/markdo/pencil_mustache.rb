module Markdo
  module PencilMustache
    class << self
      def render(template, doc)
        template.gsub(/{{.*?}}/, add_whiskers(doc))
      end

      private

      def add_whiskers(doc)
        with_whiskers = {}
        doc.keys.each { |k| with_whiskers["{{#{k}}}"] = doc[k] }
        with_whiskers
      end
    end
  end
end
