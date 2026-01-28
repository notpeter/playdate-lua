# Playdate Lua

This repository builds a patched Lua 5.4.0 with some additional patches.
It is meant to emulate a closed source lua distribution: Playdate Lua
shipped as part of the PlaydateSDK and Panic Playdate game console.
This closed source, but we attempt to closely mirror its functionality here.

## Build instructions

Compile with: `./build.sh build`
Clean with: `./build.sh clean`
Test with: `./build.sh test`

Clean will clear the contents of the `build` subdir with `git clean -fdx build`

### Build output

build/lua-prefix/src/lua/src/lua
build/lua-prefix/src/lua/src/luac

## Patches:

See: `patch/apply-patches.sh` for how patches are applied.

- `patch/scratchminer_lua54.patch`: Enables backwards support for Lua byte code compiled with 5.4.0-beta
  - Adds `OP_LOADBOOL` which was included 5.4.0-beta but removed in 5.4.0
  - Support alternate magic bytes from beta release
  - Support alternate byte code numbering ordering used by old bytecode
- `patch/table-additions.patch`: Adds Playdate-specific table helpers
  - `table.indexOfElement`, `table.getsize`, `table.create`, `table.shallowcopy`, `table.deepcopy`
- `patch/compound-assign.patch`: Enables compound assignment operators
