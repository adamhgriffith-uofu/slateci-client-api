# SLATE Client and API

> **_IMPORTANT:_** This repository requires a read-through of [CLI Access](https://portal.slateci.io/cli) beforehand and if you have questions reach out to the team via SLACK, in an email, or during the working-sessions.

Containerized SLATE CLI with API SSH access.

## Requirements

### Dockerfile Arguments

The `Dockerfile` provides the following build arguments:

| Name | Required | Description |
| --- | --- | --- |
| `env` | No | The SLATE API environment. Allowed values include `dev` and `prod` where `dev` is the default value. |
| `fabricusername` | No | The Fabric API user name for Fabric and the Bastion servers. If not specified this will be set to `username`. |
| `token` | Yes | The SLATE CLI token associated with `env`. Each SLATE API environment requires its own token CLI token. |
| `username` | Yes | The SLATE API user name for Puppet, SLATE, and the Bastion servers. The user name is shared between all SLATE environments. |

### SSH Key Files

> **_NOTE:_** All files added to `/<repo-location>/secrets` will be ignored by Git so don't worry :).

* During the build process Docker will copy relevant SSH keys into the image.
* Please copy all described keys below to `/<repo-location>/secrets` before building the images.

| Name | Required | Description |
| --- | --- | --- |
| `id_rsa_slate` | Yes | Counterpart to the public key for Puppet, SLATE, and the Bastion servers. |

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
* SSH'ing is now very simple (see the **API SSH Commands** section for additional information).

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
* SSH'ing is now very simple (see the **API SSH Commands** section for additional information).

## API SSH Commands

The `username` and API SSH keys are already applied to `~/.ssh/config` in a standard way. The upshot is that lengthy commands like the following are no longer necessary.

```shell
[root@1234 ~]$ ssh -i /path/to/key -J <username>@<bastion-hostname> -i /path/to/another/key <username>@<endpoint-hostname>
```

Instead, make use of the shorter commands described below.

### Internal SLATE API Host

```shell
[root@1234 ~]$ ssh slate-api-host
```

### External SLATE Bastion Host

```shell
[rootssh@1234 ~]$ ssh slate-bastion-host
```