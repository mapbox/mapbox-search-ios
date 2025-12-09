#!/usr/bin/env bash
set -eoux

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") project-name output-directory

Generate swift coverage files

Arguments:

    project-name        Name the project to lookup, regexp support (e.g. ^MapboxSearch$)
    output-directory    Directory to put coverate files (e.g. coverage/)
EOF
  exit
}

if [ "$#" -ne 2 ]; then
    usage
    exit 1
fi

swiftcov() {
  _dir=$(dirname "$1" | sed 's/\(Build\).*/\1/g')
  for _type in app framework xctest
  do
    find "$_dir" -name "*.$_type" | while read -r f
    do
      _proj=${f##*/}
      _proj=${_proj%."$_type"}
      if [ "$2" = "" ] || [ "$(echo "$_proj" | grep -i "$2")" != "" ];
      then
        echo "    Building reports for $_proj $_type"
        dest=$([ -f "$f/$_proj" ] && echo "$f/$_proj" || echo "$f/Contents/MacOS/$_proj")
        # shellcheck disable=SC2001
        _proj_name=$(echo "$_proj" | sed -e 's/[[:space:]]//g')
        # shellcheck disable=SC2086
        mkdir -p "${3}"
        xcrun llvm-cov show -instr-profile "$1" "$dest" > "${3}/$_proj_name.$_type.coverage.txt" \
         || echo "    llvm-cov failed to produce results for $dest"
      fi
    done
  done
}

PROF_DATA=$(find "${HOME}/Library/Developer/Xcode/DerivedData" -name '*.profdata' | head -n 1)
swiftcov "${PROF_DATA}" "$1" "$2"
