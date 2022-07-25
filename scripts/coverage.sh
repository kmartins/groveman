#!/bin/bash

# Fast fail the script on failures.
set -e

dart test -j 4 --coverage=coverage 

dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --packages=.dart_tool/package_config.json --report-on=lib