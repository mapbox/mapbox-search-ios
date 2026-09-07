#!/usr/bin/env bash

# Improvements:
# 1. Add mapbox-internal if not set (pod repo add mapbox-internal git@github.com:mapbox/pod-specs-internal.git)

set -euo pipefail

BASEDIR=$(dirname "$0")

pod repo push mapbox-internal MapboxSearch.podspec
pod repo push mapbox-internal MapboxSearchUI.podspec
