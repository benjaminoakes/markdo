require 'spec_helper'
require 'stringio'
require 'markdo/cli'

module Markdo
  describe CLI do
    describe 'given "version"' do
      it 'prints the version' do
        out = StringIO.new
        err = StringIO.new
        env = {}

        CLI.new(out, err, env).run('version')

        expect(out.string).to match(/v[0-9.]+[a-z0-9]+\n/)
      end
    end
  end
end
