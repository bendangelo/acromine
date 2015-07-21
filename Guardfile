# prevent dropping into pry when nothing is happening
interactor :off

guard :rubocop, all_on_start: true, cli: ['-D'] do
  watch(%r{.+\.rb$})
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  watch('Gemfile')
  watch('Rakefile')
end

guard :rspec, all_on_start: true, cmd: 'bundle exec rspec' do
  watch(%r{^spec/(.+)_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})           { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^spec/spec_helper.*\.rb$}) { 'spec' }
end

guard :cucumber, all_on_start: true do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$})              { 'features' }
  watch(%r{^features/step_definitions/.+\.rb$}) { 'features' }
  watch(%r{^lib/acromine})                      { 'features' }
end
