# SLATE Client and API

> **_IMPORTANT:_** This repository requires a read-through of [CLI Access](https://portal.slateci.io/cli) beforehand and if you have questions reach out to the team via SLACK, in an email, or during the working-sessions.

Containerized SLATE CLI with API SSH access. [Git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) include:
* [Kubespray](https://github.com/kubernetes-sigs/kubespray/tree/a923f4e7c0692229c442b07a531bfb5fc41a23f9) (Tag: v2.15.0 or Commit a923f4e)
* [slate-ansible](https://github.com/slateci/slate-ansible/tree/9266394ecca3b1e7e265f68cb12fe8824114ba85) (Commit 9266394).

Ansible:
* Tools have been split out into a separate Docker image as described in [README](ansible/README.md).
* FABRIC-related variables, etc. are just here to make our lives easier when dealing with SSH and Ansible inventory. Other cloud environments may be included at a later date.

## Requirements

### Dockerfile Arguments

The `Dockerfile` provides the following build arguments:

| Name             | Required | Description                                                                                                                 |
|------------------|----------|-----------------------------------------------------------------------------------------------------------------------------|
| `env`            | No       | The SLATE API environment. Allowed values include `dev` and `prod` where `dev` is the default value.                        |
| `fabricusername` | No       | The Fabric API user name for Fabric and the Bastion servers. If not specified this will be set to `username`.               |
| `token`          | Yes      | The SLATE CLI token associated with `env`. Each SLATE API environment requires its own token CLI token.                     |
| `username`       | Yes      | The SLATE API user name for Puppet, SLATE, and the Bastion servers. The user name is shared between all SLATE environments. |

### SSH Key Files

> **_NOTE:_** All files added to `/<repo-location>/secrets/ssh` will be ignored by Git so don't worry :).

* During the build process Docker will copy relevant SSH keys into the image.
* Please copy all required keys below to `/<repo-location>/secrets/ssh` before building the images.

| Name                  | Required | Description                                                                                                   |
|-----------------------|----------|---------------------------------------------------------------------------------------------------------------|
| `id_rsa_slate`        | Yes      | Counterpart to the public key for Puppet, SLATE, and the Bastion servers.                                     |
| `id_rsa_fabric`       | No       | Counterpart to the public key for Fabric and the Bastion servers.                                             |
| `id_rsa_fabric_slice` | No       | Counterpart to the public key for the Fabric Jupyter notebook where the slice has been defined and requested. |

## Build and Run

### Production

Build the Docker image with production `build-arg`s:

```shell
docker build --file Dockerfile --build-arg env=prod --build-arg token=<prod-token> --build-arg username=<username> --tag slateci-client-api:prod .
```

Running the image will create a new tagged container, print the connection information, and start up `/bin/bash`.

```shell
[your@localmachine ~]$ docker run -it -v /<repo-location>/work:/work slateci-client-api:prod
======= Connection Information ========================================================================
Endpoint: <endpoint-url>

Name ID Email Phone
First Last user_xxxx your@email.com no phone

Client Version Server Version
1234           1234          
Server supported API versions: v1alpha3
=======================================================================================================
[root@1234 ~]$
```

* Use the `/<repo-location>/work:/work` volume to mount files from your local machine to the container.
* See [SSH Commands](#ssh-commands) for information on that topic.

### Development

Build the Docker image with development `build-arg`s:

```shell
docker build --file Dockerfile --build-arg token=<dev-token> --build-arg username=<username> --tag slateci-client-api:dev .
```

Running the image will create a new tagged container, print the connection information, and start up `/bin/bash`.

```shell
[your@localmachine ~]$ docker run -it -v /<repo-location>/work:/work slateci-client-api:dev
======= Connection Information ========================================================================
Endpoint: <endpoint-url>

Name ID Email Phone
First Last user_xxxx your@email.com no phone

Client Version Server Version
1234           1234          
Server supported API versions: v1alpha3
=======================================================================================================
[root@1234 ~]$
```

* Use the `/<repo-location>/work:/work` volume to mount files from your local machine to the container.
* See [SSH Commands](#ssh-commands) for information on that topic.

## SSH Commands

The `username` and API SSH keys are already applied to `~/.ssh/config` in a standard way. The upshot is that lengthy commands like the following are no longer necessary.

```shell
ssh -i /path/to/key -J <username>@<bastion-hostname> -i /path/to/another/key <username>@<endpoint-hostname>
```

Instead, make use of the shorter command below using any of the predefined SSH hosts.

```shell
ssh <ssh-host>
```

| SSH Hosts             | Description                       |
|-----------------------|-----------------------------------|
| `fabric-bastion-host` | External Fabric SSH Bastion host. |
| `slate-bastion-host`  | External SLATE SSH Bastion host.  |   
| `slate-api-host`      | Internal SLATE API host.          |

* Not all Bastion hosts allow direct login. This is expected behavior.

## Persistent Bash History

The `bash` history  is stored in `/work/.bash_history_docker`.
* If `/work` has been specified as a volume the history will persist between containers.

```shell
[root@123 ~]# history
    1  echo 'hello world'
    2  ls -al
    3  exit
    4  history
    5  exit
    6  history
```