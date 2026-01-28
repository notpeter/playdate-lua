#!/usr/bin/env bash

set -e

case "$1" in
  clean)
    git clean -fdx build
    ;;
  build)
    cd build
    cmake ..
    make
    ;;
  test)
    cd tests
    ./run.sh
    ;;
  *)
    echo "Usage: $0 {clean|build|test}"
    exit 1
    ;;
esac
