#!/usr/bin/env python3

import yaml
import os
import sys

if len(sys.argv) != 2:
    print("Script requires yaml file argument.")
    sys.exit(1)

file_path = sys.argv[1]

yaml_content = None

if os.path.isfile(file_path):
    with open(file_path) as f:
        try:
            yaml_content = yaml.safe_load(f)
        except yaml.YAMLError:
            print("Cannot parse YAML file")

if yaml_content is None:
    # Apply default config structure
    yaml_content = {"api-downloads": "v2", "packages": {"ios": {}}}
    # yaml_content = {'api-downloads': 'v2', 'packages': {'ios': {}}, 'bundles': {'ios': {}}}

yaml_content["packages"]["ios"] = ["MapboxSearch", "MapboxSearchUI"]
# yaml_content['bundles']['ios'] = 'mapbox-search-ios-all'
new_content = yaml.dump(yaml_content, default_flow_style=False, sort_keys=False)

with open(file_path, "w") as f:
    f.write(new_content)
