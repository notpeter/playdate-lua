#!/usr/bin/env pd-lua

local function assert_equal(actual, expected, label)
    if actual ~= expected then
        error(string.format("%s: expected %s, got %s", label, tostring(expected), tostring(actual)))
    end
end

local a = 10
a += 5
assert_equal(a, 15, "plus equals")

a -= 3
assert_equal(a, 12, "minus equals")

a *= 2
assert_equal(a, 24, "multiply equals")

a /= 3
assert_equal(a, 8, "divide equals")

a //= 3
assert_equal(a, 2, "floor divide equals")

a %= 2
assert_equal(a, 0, "mod equals")

local b = 1
b <<= 3
assert_equal(b, 8, "shift left equals")

b >>= 2
assert_equal(b, 2, "shift right equals")

local c = 6
c &= 3
assert_equal(c, 2, "bit and equals")

c |= 9
assert_equal(c, 11, "bit or equals")

c ^= 10
assert_equal(c, 1, "bit xor equals")

print("operator additions tests passed")
