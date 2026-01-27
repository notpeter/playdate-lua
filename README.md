# playdate-lua

A generic 32bit Lua distribution designed to be _very similar_
to Lua on the Panic Playdate video game console device and simulator.

## Warning

This is an work-in-progres, unofficial distribution and is unaffiliated with
Panic Inc or PUC-Lua. Please don't ask them for help.

## Background

Playdate Lua is basically vanilla [PUC Lua 5.4.0](https://www.lua.org/) with a few changes:

1. Compile choices: `LUA_32BITS`

- Use `float` for `number` instead of `double` (32bit instead of 64bit)
- Use `int32_t` for `integer` instead of `int64_t` (32bit instead of 64bit)

2. Apply [patches/scratchminer_lua54.patch](patches/scratchminer_lua54.patch) (Author: [@scratchminer](https://github.com/scratchminer)):

- Support both `5.4.0` and `5.4.0-beta` magic bytes. See [MagicBytes](#magic-bytes)
- When `5.4.0-beta` magic bytes are found support alternate opcode numbering/order.

3. Apply [patches/compound-assign.patch](patches/compound-assign.patch) adapted from [patches/plusequals-5.4.0-beta.patch](patches/plusequals-5.4.0-beta.patch) (author: Dave Hayden)

- Support for [additional assignment operators](https://sdk.play.date/inside-playdate/#additional-assignment-operators)
- Adds: `+=, -=, *=, /=, //=, %=, <<=, >>=, &=, |=, ^=`.
- Original patch did not include `//=` (integer division assign) and `%=` (mod assign). Added here.

4. Apply [patches/table-additions.patch](patches/table-additions.patch) implementing [Playdate table additions](https://sdk.play.date/inside-playdate/#table-additions)

- Adds: `table.indexOfElement, table.getsize, table.create, table.shallowcopy, table.deepcopy`

### TODO

In addition to the above, the official Playdate Lua runtime has additional changes not-yet reflected in this repo:

- Remove `load` function (no parser/compiler at runtime). See [Lua No Parser](#Lua-No-Parser) below.
- Remove `require` function
- Remove most `debug.*` functions only supporting `debug.getinfo` and `debug.gettraceback`
- Remove `debug.upvaluejoin, debug.setupvalue, debug.setcstacklimit, debug.getuservalue, debug.sethook, debug.setmetatable, debug.getlocal, debug.gethook, debug.debug, debug.setuservalue, debug.setlocal, debug.getmetatable, debug.upvalueid, debug.traceback, debug.getupvalue, debug.getregistry`
- Prepocessor for `import` keyword/function, this happens at compile time not at runtime.
  - `import` includes the code found at that file
  - only the first `import` does anything, subsequent imports of the same file are non-ops
  - `import` returns like `require` but only on the first invocation
- Maybe other stuff?

## Usage

```sh
git clone https://github.com/notpeter/playdate-lua
cd playdate-lua
cd build
cmake ..
make
```

If you would like to add `pd-lua` and `pd-luac` to your path:

```sh
cd build/lua-prefix/src/lua/src
ln -s "${PWD}/lua" "${HOME}/.local/bin/pd-lua"
ln -s "${PWD}/luac" "${HOME}/.local/bin/pd-luac"
```

## Patches

### Lua No Parser

> [noparser.c](https://www.lua.org/extras/5.4/noparser.c) - "used to make a Lua core that does not contain the
> parsing modules (lcode, llex, lparser), which represent 20% of the total core.
> You'll only be able to load binary files and strings, precompiled with luac.
> (Of course, you'll have to build luac with the original parsing modules!)

This makes `luaY_parser`, `luaU_dump`, `luaU_undump` functions NO-OPs.

- Author: Lua.org, PUC-Rio
- License: MIT

### Compound Assignment Operators

> [pluseqals-5.4.patch](http://lua-users.org/files/wiki_insecure/B4rtzUB3/5.4/plusequals-5.4.patch) - "An update to SvenOlsen's popular compound assignment operator patch, allowing statements
> like "object.counter += 2". In addition to 5.4 (beta) compatibility, this adds shift and
> bitwise operators (<<=, >>=, &=, |=, and ^=) to the previously implemented +=, -=, \*=, and /=.
> The ++ increment operator isn't included because it suggests a matching --, which is already
> used for comments. (And "+= 1" is only two more characters.) Also, compound assignment on
> tuples isn't supported, because (IMO) it makes it too easy to write really confusing Lua code,
> with little gain."

- Author: Dave Hayden (dave @ panic.com) and Sven Olsen
- Link: http://lua-users.org/wiki/LuaPowerPatches
- More info: [Lua-L Mailing list](https://www.lua.org/lua-l.html) thread links:
  [2019-12](http://lua-users.org/lists/lua-l/2019-12/threads.html#00102)
  and [2020-01](http://lua-users.org/lists/lua-l/2020-01/threads.html#00009)
- License: UNKNOWN

Adapted by Peter Tripp to include `//=` (integer division assign) and `%=` (mod assign) support.

### Table Additions

Adds Playdate convenience functions for table handling:

- `table.indexOfElement`
- `table.getsize`
- `table.create`
- `table.shallowcopy`,
- `table.deepcopy`.

I have done minimal validation their behavior.
Possibility of different behavior as compared to Playdate Lua.

- Author: Peter Tripp
- License: MIT OR APACHE-2.0

### Magic Bytes

Add backwards compatibility to handle compiled with earlier PlaydateSDK versions
which generated alternate magic bytes in their Lua byte code headers.

| Bytes                                                                      | Description              |
| -------------------------------------------------------------------------- | ------------------------ |
| 0x 1B 4C 75 61 54 00 19 93 0D 0A 1A 0A 04 04 04 78 56 00 00 00 40 B9 43    | 32bit PUC Lua 5.4.0      |
| 0x 1B 4C 75 61 03 F8 00 19 93 0D 0A 1A 0A 04 04 04 78 56 00 00 00 40 B9 43 | 32bit PUC Lua 5.4.0-beta |

## Thanks/References/Links

[@jaames](https://github.com/jaames) and
[@Scratchminer](https://github.com/scratchminer)
deserve most of the credit for this work.

This repo is largely equivalent to [scratchminer/lua](https://github.com/scratchminer/lua54)
but is maintained as a set of explicit patches to be applied to
[upstream v5.4.0](https://github.com/lua/lua/releases/tag/v5.4.0)
rather than git commits added onto a fork from the same.

See also: [jaames/playdate-reverse-engineering/](https://github.com/cranksters/playdate-reverse-engineering)
which includes all sorts of internal playdate details including [formats/luac](https://github.com/cranksters/playdate-reverse-engineering/blob/main/formats/luac.md) documentation.

## Licenses

The code in this repo is offered under terms of the [MIT license](LICENSE).

3rd party components:

| Component                                                                                         | License | Copyright                                |
| ------------------------------------------------------------------------------------------------- | ------- | ---------------------------------------- |
| playdate-lua                                                                                      | MIT     | Copyright (c) Peter Tripp                |
| [lua-5.4.0.tar.gz](https://www.lua.org/ftp/lua-5.4.0.tar.gz)                                      | MIT     | Copyright (c) Lua.org, PUC-Rio           |
| [noparser.c](https://www.lua.org/extras/5.4/noparser.c)                                           | MIT     | Copyright (c) Lua.org, PUC-Rio           |
| [pluseqals-5.4.patch](http://lua-users.org/files/wiki_insecure/B4rtzUB3/5.4/plusequals-5.4.patch) | Unknown | Copyright (c) Sven Olsen and Dave Hayden |
| [playdate-reverse-engineering](https://github.com/cranksters/playdate-reverse-engineering)        | CC0     | Copyright (c) James Daniel               |
