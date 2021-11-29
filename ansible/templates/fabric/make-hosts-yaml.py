# Author: Fengping Hu
#
# Instructions:
#   1. Add the following as a new cell in a notebook hosted on Fabric's Jupyter Notebook Hub where you have defined
#      and requested a slice.
#   2. Add `hosts.j2` adjacent to that notebook in the file system.
#   3. Evaluate this code.
#   4. Once `hosts.yaml` has been generated copy it to `/submodules/kubespray/inventory/fabric/hosts.yaml` in this
#      repository.
#   5. Copy the file whose path is `ssh_key_file_priv` to `/secrets/ssh/id_rsa_fabric_slice` in this repository.
#

import yaml
from jinja2 import Environment, FileSystemLoader

# Load template file:
env = Environment(loader = FileSystemLoader('./'), trim_blocks=True, lstrip_blocks=True)
template = env.get_template('hosts.j2')

# Create Ansible hosts.yaml:
file=open("hosts.yaml", "w")
file.write(template.render(hosts=nodes,
                           bastion_public_addr=bastion_public_addr,
                           bastion_username=bastion_username,
                           bastion_key_filename=bastion_key_filename,
                           ssh_key_file_priv=ssh_key_file_priv))
file.close()
