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
  patch_dir="$3"
  if [ -z "$patch_dir" ]; then
    patch_dir="src"
  fi
  if [ ! -f "$marker" ]; then
    patch --batch -p1 -d "$patch_dir" < "$patch_file"
    touch "$marker"
  fi
}

apply_patch "scratchminer_lua54" "scratchminer_lua54.patch" "src"
apply_patch "compound_assign" "compound-assign.patch" "src"
apply_patch "table_additions" "table-additions.patch" "src"
