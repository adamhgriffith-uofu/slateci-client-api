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
