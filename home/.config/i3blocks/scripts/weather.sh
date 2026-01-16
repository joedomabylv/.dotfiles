#!/usr/bin/env bash
# simple weather using wttr.in, no api key needed
# output example: 63°F

set -euo pipefail

# san diego
# format: temperature only
curl -fsS 'https://wttr.in/San%20Diego?format=%t' | sed 's/+//'
