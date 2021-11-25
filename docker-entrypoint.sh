#!/bin/bash

# Enable strict mode:
set -euo pipefail

# Load environmental values:
source "/slate-scripts/yml.sh"
create_variables "/slate-envs/${SLATE_ENV}.yml" "conf_"

# Set the endpoint:
echo "https://${conf_api_hostname}:${conf_api_port}" > "$HOME/.slate/endpoint"

# Create the SSH configuration file:
cat > "$HOME/.ssh/config" <<EOF
### The External SLATE Bastion host
Host slate-bastion-host
  HostName ${conf_bastion_hostname}
  Port ${conf_bastion_port}
  User ${SLATE_API_USER}
  IdentityFile /root/.ssh/id_rsa_slate

### The internal SLATE API host
Host slate-api-host
  HostName ${conf_api_hostname}
  Port ${conf_bastion_port}
  User ${SLATE_API_USER}
  IdentityFile /root/.ssh/id_rsa_slate
  ProxyJump slate-bastion-host

EOF
chmod 600 "$HOME/.ssh/config"

# Test SLATE API connection for errors:
slate whoami > /dev/null

# Connection Information:
echo "======= Connection Information ========================================================================"
echo Endpoint: $(cat "$HOME/.slate/endpoint")
echo ""
echo "$(slate whoami 2>&1 | head -n 2)"
echo ""
slate version
echo "======================================================================================================="

cd "/work"
/bin/bash