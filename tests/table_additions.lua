#!/usr/bin/env pd-lua

local function assert_equal(actual, expected, label)
    if actual ~= expected then
        error(string.format("%s: expected %s, got %s", label, tostring(expected), tostring(actual)))
    end
end

local t = table.create(3, 2)
t[1] = "a"
t[2] = "b"
t.x = 1

assert_equal(table.indexOfElement(t, "b"), 2, "indexOfElement")
assert_equal(table.indexOfElement(t, "missing"), nil, "indexOfElement missing")

local array_count, hash_count = table.getsize(t)
assert_equal(array_count, 3, "getsize array")
assert_equal(hash_count, 2, "getsize hash")

local shallow = table.shallowcopy({ 1, { 2 } })
assert_equal(shallow[1], 1, "shallowcopy value")
assert_equal(type(shallow[2]), "table", "shallowcopy nested type")

local deep = table.deepcopy({ 1, { 2 } })
assert_equal(deep[1], 1, "deepcopy value")
if deep[2] == shallow[2] then
    error("deepcopy nested table should be copied")
end

local a = {}
a.self = a
local copied = table.deepcopy(a)
assert_equal(copied, copied.self, "deepcopy cycle")

print("table additions tests passed")
