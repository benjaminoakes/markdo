unless RUBY_ENGINE == 'opal'
  require 'simplecov'
  SimpleCov.start
end

require 'stringio'

def build_command_support(env = {})
  stdin = StringIO.new
  stdout = StringIO.new
  stderr = StringIO.new
  Markdo::CommandSupport.new(stdin: stdin, stdout: stdout, stderr: stderr, env: env)
end

def build_command_support_for_date_commands
  stdin = StringIO.new
  stdout = StringIO.new
  stderr = StringIO.new
  env = {
    'MARKDO_ROOT' => 'spec/fixtures/date_commands',
    'MARKDO_INBOX' => 'Inbox.md'
  }
  today = Date.new(2016, 2, 28)

  Markdo::CommandSupport.new(stdin: stdin, stdout: stdout, stderr: stderr, env: env, today: today)
end

def build_date_commands_support
  out, err = build_command_support
  env = {
    'MARKDO_ROOT' => 'spec/fixtures/date_commands',
    'MARKDO_INBOX' => 'Inbox.md'
  }

  [out, err, env, Date.new(2016, 2, 28)]
end

def assert_equality(left, right)
  expect(left).to eq(left)

  expect(left).to eq(right)
  expect(right).to eq(left)

  expect(right).to eq(right)
end

def assert_inequality(left, right)
  expect(left).not_to eq(right)
  expect(right).not_to eq(left)
end
