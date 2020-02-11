#!/usr/bin/env ruby

require 'highline'
require 'json'

VERSION_FILE = 'package.json'.freeze

cli = HighLine.new

package_json = JSON.parse(File.read(VERSION_FILE))

VERSION_NAME = package_json['version'].freeze
BUILD_NUMBER = package_json['versionCode'].freeze

# Automatically bump the minor version and reset patch
major, minor = VERSION_NAME.split('.')
new_version_name = [major, minor.to_i + 1, 0].join('.')

# Increment the build number
new_build_number = (BUILD_NUMBER.to_i + 1).to_s

# Prompt for a new version
cli.say "Current version name: #{VERSION_NAME}"
cli.say "Current build number: #{BUILD_NUMBER}"
cli.say "\n"

new_version_name = cli.ask('Enter new version name ') { |q| q.default = new_version_name }
new_build_number = cli.ask('Enter new build number ') { |q| q.default = new_build_number }

# Update version in package.json
TMP_VERSION_FILE = "/tmp/#{VERSION_FILE}".freeze
`jq '.version = "#{new_version_name}" | .versionCode = "#{new_build_number}"' #{VERSION_FILE} > #{TMP_VERSION_FILE}`
`cp #{TMP_VERSION_FILE} #{VERSION_FILE}`

cli.say "\n"

answer = cli.ask('Create the release branch? [y]') { |q| q.default = 'y' }
if answer == 'y'
  release_branch_name = "release/#{new_version_name}"
  `git checkout -b #{release_branch_name}`
  `git commit -am "Version bump to #{new_version_name} (#{new_build_number})"`

  answer = cli.ask('Push the release branch? [y]') { |q| q.default = 'y' }
  `git push origin #{release_branch_name}` if answer == 'y'
end
