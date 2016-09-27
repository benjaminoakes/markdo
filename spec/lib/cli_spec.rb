require 'spec_helper'
require 'stringio'
require 'markdo/cli'

module Markdo
  describe CLI do
    describe 'given "version"' do
      it 'prints the version' do
        out, err, env = build_command_support

        CLI.new(out, err, env).run('version')

        assert_version_printed out
      end
    end

    describe 'given an unknown command' do
      it 'defaults to help text' do
        out, err, env = build_command_support
        expect(Kernel).to receive(:exit).with(1)

        CLI.new(out, err, env).run('asdf')

        assert_help_printed err
      end
    end

    def assert_version_printed(io)
      expect(io.string).to match(/v[0-9.]+[a-z0-9]+\n/)
    end

    def assert_help_printed(io)
      expect(io.string).to match(/^Markdown-based task manager\./)
    end
  end
end
