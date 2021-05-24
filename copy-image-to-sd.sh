#!/bin/bash
set -euo pipefail

pv result.img | dd of=/dev/sdb bs=1M