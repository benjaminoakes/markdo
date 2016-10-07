require 'spec_helper'
require 'markdo/cli'

module Markdo
  describe CLI do
    describe 'given "version"' do
      it 'prints the version' do
        command_support = build_command_support

        CLI.new(command_support).run('version')

        assert_version_printed command_support.stdout
      end
    end

    describe 'given "--version"' do
      it 'prints the version' do
        command_support = build_command_support

        CLI.new(command_support).run('--version')

        assert_version_printed command_support.stdout
      end
    end

    describe 'given "--help"' do
      it 'prints help text' do
        command_support = build_command_support
        expect(Kernel).to receive(:exit).with(1)

        CLI.new(command_support).run('--help')

        assert_help_printed command_support.stderr
      end
    end

    describe 'given "starred"' do
      it 'delegates to StarCommand' do
        command_support = build_command_support
        expect(StarCommand).to receive(:new).and_return(FakeCommand.new)

        CLI.new(command_support).run('starred')
      end
    end

    describe 'given "q"' do
      it 'delegates to StarCommand' do
        command_support = build_command_support
        expect(QueryCommand).to receive(:new).and_return(FakeCommand.new)

        CLI.new(command_support).run('q')
      end
    end

    describe 'given an unknown command' do
      it 'defaults to help text' do
        command_support = build_command_support
        expect(Kernel).to receive(:exit).with(1)

        CLI.new(command_support).run('asdf')

        assert_help_printed command_support.stderr
      end
    end

    def assert_version_printed(io)
      expect(io.string).to match(/v[0-9.]+[a-z0-9]+\n/)
    end

    def assert_help_printed(io)
      expect(io.string).to match(/^Markdown-based task manager\./)
    end

    class FakeCommand
      def run
      end
    end
  end
end
