#!/bin/bash

# Enable strict mode:
set -euo pipefail

# Connection Information:
echo "======= Connection Information ========================================================================"
echo Endpoint: $(cat "$HOME/.slate/endpoint")
echo ""
echo "$(slate whoami 2>&1 | head -n 2)"
echo ""
slate version
echo "======================================================================================================="

cd ~
/bin/bash