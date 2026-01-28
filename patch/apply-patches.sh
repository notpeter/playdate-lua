#!/bin/sh
set -e

PATCH_DIR="$(dirname "$0")"
SRC_DIR="$1"
if [ -z "$SRC_DIR" ]; then
  echo "usage: apply-patches.sh <src-dir>" >&2
  exit 1
fi

apply_patch() {
  marker="$SRC_DIR/.patched_$1"
  patch_file="$PATCH_DIR/$2"
  patch_dir="$3"
  if [ -z "$patch_dir" ]; then
    patch_dir="$SRC_DIR"
  fi
  if [ ! -f "$marker" ]; then
    patch --batch -p1 -d "$patch_dir" < "$patch_file"
    touch "$marker"
  fi
}

apply_patch "lua32" "lua32.patch" "$SRC_DIR"
apply_patch "scratchminer" "scratchminer.patch" "$SRC_DIR"
apply_patch "compound_assign" "compound-assign.patch" "$SRC_DIR"
apply_patch "table_additions" "table-additions.patch" "$SRC_DIR"
