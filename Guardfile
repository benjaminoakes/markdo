# vim: set ft=ruby:

guard 'rake', task: 'compile_opal' do
  watch %r{^lib/.+\.rb$}
end

guard 'rake', task: 'spec:opal:phantomjs' do
  watch %r{^lib/.+\.rb$}
  watch %r{^spec/.+\.rb$}
end

guard 'rake', task: 'spec' do
  watch %r{^lib/.+\.rb$}
  watch %r{^spec/.+\.rb$}
end
