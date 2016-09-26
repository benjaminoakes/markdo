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
