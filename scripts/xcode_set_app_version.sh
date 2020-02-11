#!/bin/bash

# This script is automatically executed after 'Copy Bundle Resources' build phase.
# For more details see:
#   http://tgoode.com/2014/06/05/sensible-way-increment-bundle-version-cfbundleversion-xcode/
#   https://www.mokacoding.com/blog/automatic-xcode-versioning-with-git/
#   https://fuller.li/posts/versioning-with-xcode-and-git/

# Print commands before executing them (useful for troubleshooting)
set -x

PACKAGE_JSON_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/package.json"

function read_package_json () {
  ruby -e "require 'json'; puts JSON.parse(STDIN.read)['$1']" < "${PACKAGE_JSON_PATH}"
}

VERSION_NAME=$(read_package_json 'version')
VERSION_CODE=$(read_package_json 'versionCode')

TARGET_PLIST="${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"
DSYM_PLIST="${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Info.plist_file"

for plist_file in "${TARGET_PLIST}" "${DSYM_PLIST}"; do
  if [ -f "${plist_file}" ]; then
    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${VERSION_CODE}" "${plist_file}"
    /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${VERSION_NAME}" "${plist_file}"
  fi
done
