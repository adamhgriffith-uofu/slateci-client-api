#!/bin/bash

# Enable strict mode:
set -euo pipefail

# Welcome message
echo "********************* Metadata *********************"
echo Connection: $(cat "$HOME/.slate/endpoint")
echo "****************************************************"

/bin/bash