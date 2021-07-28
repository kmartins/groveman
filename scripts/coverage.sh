#!/bin/bash

# Fast fail the script on failures.
set -e

dart test --coverage="coverage"

format_coverage --lcov --in=coverage --out=coverage/lcov.info --packages=.packages --report-on=lib