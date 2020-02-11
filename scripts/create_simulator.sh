#!/bin/bash

# Creates iPhone simulator with desired configuration
# for development and running e2e tests.

xcrun simctl delete all

xcrun simctl create \
  "iPhone 7" \
  com.apple.CoreSimulator.SimDeviceType.iPhone-7 \
  com.apple.CoreSimulator.SimRuntime.iOS-13-2
