#!/bin/sh
set -e

PATCH_DIR="$1"
if [ -z "$PATCH_DIR" ]; then
  echo "usage: apply-patches.sh <patch-dir>" >&2
  exit 1
fi

apply_patch() {
  marker="src/.patched_$1"
  patch_file="$PATCH_DIR/$2"
  if [ ! -f "$marker" ]; then
    patch -p1 -d src < "$patch_file"
    touch "$marker"
  fi
}

apply_patch "scratchminer_lua54" "scratchminer_lua54.diff"
apply_patch "table_additions" "table-additions.patch"
