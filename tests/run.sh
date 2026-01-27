#!/bin/sh
set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LUA_BIN="$ROOT_DIR/build/lua-prefix/src/lua/src/lua"

if [ ! -x "$LUA_BIN" ]; then
  echo "Lua binary not found at $LUA_BIN" >&2
  echo "Build first: cd build && cmake .. && make" >&2
  exit 1
fi

"$LUA_BIN" "$ROOT_DIR/tests/table_additions.lua"
"$LUA_BIN" "$ROOT_DIR/tests/operator_additions.lua"
"$LUA_BIN" "$ROOT_DIR/tests/build_config.lua"
