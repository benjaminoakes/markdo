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

    describe 'given an unknown command' do
      it 'defaults to help text' do
        out = StringIO.new
        err = StringIO.new
        env = {}
        expect(Kernel).to receive(:exit).with(1)

        CLI.new(out, err, env).run('asdf')

        expect(err.string).to match(/^Markdown-based task manager\./)
      end
    end
  end
end
