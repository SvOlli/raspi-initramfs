#!/bin/sh

set -ex

if [ -z "$part1" ]; then
  printf "Error: missing environment variable part1\n" 1>&2
  exit 1
fi

