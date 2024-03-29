# playdate-lua

A generic 32bit Lua distribution designed to be *very similar*
to Lua on the Panic Playdate video game console device and simulator.

## Warning

This is an work-in-progres, unofficial distribution and is unaffiliated with
Panic Inc or PUC-Lua. Please don't ask them for help.

## Background

Playdate Lua is basically vanilla [PUC Lua 5.4.0](https://www.lua.org/) with a few changes:
1. C Type for a Lua `number` is normally `double` but here it's `float` (32bit instead of 64bit)
2. C Type for a Lua `integer` is normally `int64_t` but here it's `int32_t` (32bit instead of 64bit)
3. The Lua runtime adds backward compatibility for an alternate, earlier set of magic bytes in the lua bytecode header.
See [MagicBytes](#magic-bytes)
4. Lua Opcodes are slightly different.
It's basically the Lua 5.4.0-beta opcodes with the new opcodes from Lua 5.4.0 appended to the end.
5. Support for [additional assignment operators](https://sdk.play.date/inside-playdate/#additional-assignment-operators):
`+=, -=, *=, /=, //=, %=, <<=, >>=, &=, |=, ^=`.

> TODO: Apply this [patch](http://lua-users.org/files/wiki_insecure/RoP4pD5d/5.4/plusequals-5.4.3.patch)

> Note: playdate-lua does not currently duplicate the following behaviors:

6. Separate stripped down Lua runtime for device/simulator which cannot parse or compile lua source
code and can only operate with pre-compiled lua bytecode (`*.luac`)
generated by `luac` (Lua Compiler) or the `pdc` (Playdate Compiler).

7. The stripped down Lua runtime does not include some standard library functions:
    * `require` (see `import` below)
    * `load` (no parser/compiler at runtime)
    * `debug.upvaluejoin, debug.setupvalue, debug.setcstacklimit, debug.getuservalue, debug.sethook, debug.setmetatable, debug.getlocal, debug.gethook, debug.debug, debug.setuservalue, debug.setlocal, debug.getmetatable, debug.upvalueid, debug.traceback, debug.getupvalue, debug.getregistry`
    * while `debug.getinfo` and `debug.gettraceback` are available

8. New functions added to the standard libary:
    * [table additions](https://sdk.play.date/inside-playdate/#table-additions):
    `table.indexOfElement, table.getsize, table.create, table.shallowcopy, table.deepcopy`
9. `import` function replacing `require`. At compile-time `pdc` compiles all imported lua
together as a single pdz (gzip compressed blob of `lauc` byte code).
The `import` function is unused at runtime.

10. Maybe other stuff?

## How to use it?

```
git clone https://github.com/notpeter/playdate-lua
cd plakydate-lua
cd build
cmake ..
make
```

TBD

## Patches

### Lua No Parser

> [noparser.c](https://www.lua.org/extras/5.4/noparser.c) - "used to make a Lua core that does not contain the
parsing modules (lcode, llex, lparser), which represent 20% of the total core.
You'll only be able to load binary files and strings, precompiled with luac.
(Of course, you'll have to build luac with the original parsing modules!)

This makes `luaY_parser`, `luaU_dump`, `luaU_undump` functions NO-OPs.

* Author: Lua.org, PUC-Rio
* License: MIT

### Lua Opcode Renumbering

### Compound Assignment Operators

> [pluseqals-5.4.patch](http://lua-users.org/files/wiki_insecure/B4rtzUB3/5.4/plusequals-5.4.patch) - "An update to SvenOlsen's popular compound assignment operator patch, allowing statements
like "object.counter += 2". In addition to 5.4 (beta) compatibility, this adds shift and
bitwise operators (<<=, >>=, &=, |=, and ^=) to the previously implemented +=, -=, *=, and /=.
The ++ increment operator isn't included because it suggests a matching --, which is already
used for comments. (And "+= 1" is only two more characters.) Also, compound assignment on
tuples isn't supported, because (IMO) it makes it too easy to write really confusing Lua code,
with little gain."

* Author: Dave Hayden (dave @ panic.com) and Sven Olsen
* Link: http://lua-users.org/wiki/LuaPowerPatches
* More info: [Lua-L Mailing list](https://www.lua.org/lua-l.html) thread links:
[2019-12](http://lua-users.org/lists/lua-l/2019-12/threads.html#00102)
and [2020-01](http://lua-users.org/lists/lua-l/2020-01/threads.html#00009)
* License: UNKNOWN

### Magic Bytes

Add backwards compatibility to handle compiled with earlier PlaydateSDK versions
which generated alternate magic bytes in their Lua byte code headers.

| Bytes | Description
| ----- | -----------
| 0x 1B 4C 75 61  54 00 19 93 0D 0A 1A 0A 04 04 04 78 56 00 00 00 40 B9 43 | 32bit PUC Lua 5.4.0
| 0x 1B 4C 75 61  03 F8 00 19 93 0D 0A 1A 0A 04 04 04 78 56 00 00 00 40 B9 43 | 32bit PUC Lua 5.4.0-beta

## Thanks/References/Links

[@jaames](https://github.com/jaames) and
[@Scratchminer](https://github.com/scratchminer)
deserve most of the credit for this work.

This repo is largely equivalent to [scratchminer/lua](https://github.com/scratchminer/lua54)
but is maintained as a set of patches to be applied to
[upstream v5.4.0](https://github.com/lua/lua/releases/tag/v5.4.0)
rather than as git commits forking from [upstream v5.4.0

While [jaames/playdate-reverse-engineering/](https://github.com/cranksters/playdate-reverse-engineering)
includes all sorts of internal playdate details including [formats/luac](https://github.com/cranksters/playdate-reverse-engineering/blob/main/formats/luac.md) documentation.

## Licenses

The code in this repo is offered under terms of the [MIT license](LICENSE).

3rd party components:

| Component  | License | Copyright
| ---------- | ------- | --------- |
| playdate-lua | MIT   | Copyright (c) Peter Tripp
| [lua-5.4.0.tar.gz](https://www.lua.org/ftp/lua-5.4.0.tar.gz)  | MIT     | Copyright (c) Lua.org, PUC-Rio
| [noparser.c](https://www.lua.org/extras/5.4/noparser.c) | MIT | Copyright (c) Lua.org, PUC-Rio
| [pluseqals-5.4.patch](http://lua-users.org/files/wiki_insecure/B4rtzUB3/5.4/plusequals-5.4.patch) | Unknown | Copyright (c) Sven Olsen and Dave Hayden |
| [playdate-reverse-engineering](https://github.com/cranksters/playdate-reverse-engineering) | CC0 | Copyright (c) James Daniel
