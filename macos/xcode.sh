#!/usr/bin/env zsh

# install xcode command line tools
if ! exists xcode-select --print-path; then
  xcode-select --install &> /dev/null

  # wait until installed
  until exists xcode-select --print-path; do
    sleep 5
  done

  echo "Xcode command line tools installed"
fi
