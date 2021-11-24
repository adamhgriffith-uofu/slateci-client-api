# SLATE Client & Access

> **_IMPORTANT:_** This repository requires a read-through of [CLI Access](https://portal.slateci.io/cli) in order to make any sense.

Containerized SLATE CLI with API SSH access.

## Requirements

### Dockerfile Arguments

The `Dockerfile` provides the following build arguments:

| Name | Required | Description |
| --- | --- | --- |
| `endpoint` | Yes | See [CLI Access](https://portal.slateci.io/cli) and/or meeting notes for the development values. |
| `token` | Yes | See [CLI Access](https://portal.slateci.io/cli) and/or meeting notes for the development values. |
| `username` | Yes | The SLATE API username sent to Lincoln Bryant for integration with Puppet, SLATE, and the Bastion servers. |

### SSH Key Files

> **_NOTE:_** Keys added to `/<repo-location>/ssh` will be ignored by git.

During the build process Docker will copy relevant SSH keys into the image.

| Name | Required | Description |
| --- | --- | --- |
| `id_rsa` | Yes | Counterpart to the public key sent to Lincoln Bryant for Puppet, SLATE, and the Bastion servers. |

## Build and Run

### Production

Build the Docker image with production `build-arg`s:

```shell
docker build --file Dockerfile --build-arg endpoint=<prod-endpoint> --build-arg token=<prod-token> --build-arg username=<username> --tag slateci-client-api:prod .
```

Running the image will create a new tagged container, print the connection information, and start up `/bin/bash`.

```shell
[your@desktop ~]$ docker run -it -v /<repo-location>/work:/work slateci-client-api::prod
======= Connection Information ========================================================================
Endpoint: <endpoint-url>

Name ID Email Phone
First Last user_xxxx your@email.com no phone

Client Version Server Version
1234           1234          
Server supported API versions: v1alpha3
=======================================================================================================
[username@1234 ~]$
```

* Use the `/<repo-location>/work:/work` volume to mount files from your machine to the container.

### Development

Build the Docker image with development `build-arg`s:

```shell
docker build --file Dockerfile --build-arg endpoint=<dev-endpoint> --build-arg token=<dev-token> --build-arg username=<username> --tag slateci-client-api:dev .
```

Running the image will create a new tagged container, print the connection information, and start up `/bin/bash`.

```shell
[your@desktop ~]$ docker run -it -v /<repo-location>/work:/work slateci-client-api::dev
======= Connection Information ========================================================================
Endpoint: <endpoint-url>

Name ID Email Phone
First Last user_xxxx your@email.com no phone

Client Version Server Version
1234           1234          
Server supported API versions: v1alpha3
=======================================================================================================
[username@1234 ~]$
```

* Use the `/<repo-location>/work:/work` volume to mount files from your machine to the container.

## API SSH Commands

The `username` and API SSH keys are already applied to the container in a standard way. Therefore, the once lengthy `ssh` commands may now be severely shortened. For example:

```shell
[username@1234 ~]$ ssh -i /path/to/key -J <username>@<bastion-hostname> <username>@<endpoint-hostname>
```

becomes:

```shell
[username@1234 ~]$ ssh -J <bastion-hostname> <endpoint-hostname>
```

