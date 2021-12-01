#!/usr/bin/env bash

curl -u ${CIRCLE_CI_TOKEN}: -X POST --header "Content-Type: application/json" -d '{ "parameters": { "run_ios_search": true }}' \
  https://circleci.com/api/v2/project/github/mapbox/mobile-metrics/pipeline
