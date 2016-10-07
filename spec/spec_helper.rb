unless RUBY_ENGINE == 'opal'
  require 'simplecov'
  SimpleCov.start
end

require 'stringio'

def build_command_support(env = {})
  out = StringIO.new
  err = StringIO.new
  Markdo::CommandSupport.new(stdout: out, stderr: err, env: env)
end

def build_command_support_for_date_commands
  out = StringIO.new
  err = StringIO.new
  env = {
    'MARKDO_ROOT' => 'spec/fixtures/date_commands',
    'MARKDO_INBOX' => 'Inbox.md'
  }
  today = Date.new(2016, 2, 28)

  Markdo::CommandSupport.new(stdout: out, stderr: err, env: env, today: today)
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
