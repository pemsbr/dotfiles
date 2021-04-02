#!/usr/bin/env zsh

XCODE_VERSION=$(xcodebuild -version | awk 'NR==1{print $2}')
ACCEPTED_LICENSE_VERSION=$(defaults read /Library/Preferences/com.apple.dt.Xcode IDEXcodeVersionForAgreedToGMLicense)
readonly XCODE_VERSION
readonly ACCEPTED_LICENSE_VERSION

# Install Xcode Command Line Tools
if ! exists xcode-select --print-path; then
  xcode-select --install &> /dev/null

  # Wait until the Xcode Command Line Tools are installed
  until exists xcode-select --print-path; do
    sleep 5
  done

  echo "Xcode command line tools installed"
fi

# Accept Xcode license
if ! [[ $XCODE_VERSION = "$ACCEPTED_LICENSE_VERSION" ]]; then  
  echo "Xcode license needs to be accepted."
  sudo xcodebuild -license accept
  sudo xcodebuild -runFirstLaunch
fi