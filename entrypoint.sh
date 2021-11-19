#!/bin/bash

# Enable strict mode:
set -euo pipefail

# May not need this with key in standard location.
#exec ssh-agent bash
#ssh-add $HOME/.ssh/id_rsa

# Connection Information:
echo "======= Connection Information ========================================================================"
echo Endpoint: $(cat "$HOME/.slate/endpoint")
echo ""
echo "$(slate whoami 2>&1 | head -n 2)"
echo ""
slate version
echo "======================================================================================================="

cd $HOME
/bin/bash