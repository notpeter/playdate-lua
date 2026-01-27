local function assert_equal(actual, expected, label)
  if actual ~= expected then
    error(string.format("%s: expected %s, got %s", label, tostring(expected), tostring(actual)))
  end
end

assert_equal(math.maxinteger, 2147483647, "math.maxinteger")

local packed = string.pack("J", 0)
assert_equal(#packed, 4, "string.pack J size")

print("build config tests passed")
