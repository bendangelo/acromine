Given(/^the number of longforms should( not)? be greater than (\d+)$/) do |negate, expected|
  actual = last_command.stdout.split(/\n/).size - 1
  if negate
    expect(actual).not_to be > expected.to_i
  else
    expect(actual).to be > expected.to_i
  end
end
