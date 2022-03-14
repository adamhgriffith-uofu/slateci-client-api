#!/bin/bash

# Enable strict mode:
set -euo pipefail

# For those using the same user account for Fabric and SLATE:
if [ -z "$FABRIC_API_USER" ]
then
  FABRIC_API_USER="${SLATE_API_USER}"
fi

# Create the bash history file if necessary:
if [ ! -f "$HISTFILE" ]
then
  touch /work/.bash_history_docker
fi

# Load environmental values:
source "/docker/scripts/yml.sh"
create_variables "/docker/envs/${SLATE_ENV}.yml" "conf_"
export SLATE_API_ENDPOINT="https://${conf_slate_api_hostname}:${conf_slate_api_port}"

# Create the SSH configuration file:
cat > "$HOME/.ssh/config" <<EOF
### Global Settings
StrictHostKeyChecking no
UserKnownHostsFile /dev/null

### The External Fabric Bastion host
Host fabric-bastion-host
  HostName ${conf_fabric_bastion_hostname}
  IdentitiesOnly yes
  IdentityFile /root/.ssh/id_rsa_fabric
  Port ${conf_fabric_bastion_port}
  User ${FABRIC_API_USER}

### The External SLATE Bastion host
Host slate-bastion-host
  HostName ${conf_slate_bastion_hostname}
  IdentitiesOnly yes
  IdentityFile /root/.ssh/id_rsa_slate
  Port ${conf_slate_bastion_port}
  User ${SLATE_API_USER}

### The internal SLATE API host
Host slate-api-host
  HostName ${conf_slate_api_hostname}
  IdentityFile /root/.ssh/id_rsa_slate
  Port ${conf_slate_bastion_port}
  ProxyJump slate-bastion-host
  User ${SLATE_API_USER}

### The internal SLATE Portal host
Host slate-portal-host
  HostName ${conf_slate_portal_hostname}
  IdentityFile /root/.ssh/id_rsa_slate
  Port ${conf_slate_portal_port}
  ProxyJump slate-bastion-host
  User ${SLATE_API_USER}
EOF
chmod 600 "$HOME/.ssh/config"

# Test SLATE API connection for errors:
slate whoami > /dev/null

# Connection Information:
echo "======= Connection Information ========================================================================"
echo Endpoint: $(echo "$SLATE_API_ENDPOINT")
echo ""
echo "$(slate whoami 2>&1 | head -n 2)"
echo ""
slate version
echo "======================================================================================================="

cd "/work"
${1:-/bin/bash}