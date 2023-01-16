#!/usr/bin/env bash

set -eoux

pip3 install --user codecov
env -i python3 -m \
		codecov \
		--root "$(pwd)" \
		--file "$1" \
		--required || echo 'Codecov failed to upload'
