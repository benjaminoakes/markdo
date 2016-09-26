# vim: set ft=ruby:

guard 'rake', task: 'test' do
  watch %r{^lib/.+\.rb$}
  watch %r{^test/.+\.rb$}
end

guard 'rake', task: 'spec' do
  watch %r{^lib/.+\.rb$}
  watch %r{^spec/.+\.rb$}
end

guard 'rake', task: 'spec:opal' do
  watch %r{^lib/.+\.rb$}
  watch %r{^spec/.+\.rb$}
end
