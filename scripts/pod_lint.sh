#!/usr/bin/env bash
set -euo pipefail

pod lib lint MapboxSearch.podspec --silent
pod lib lint MapboxSearchUI.podspec --include-podspecs=MapboxSearch.podspec --silent
