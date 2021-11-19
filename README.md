# slateci-client-access

> **_NOTE:_** This repository requires a read-through of [CLI Access](https://portal.slateci.io/cli) in order to make any sense.

Containerized SLATE CLI access.

## Arguments

The `Dockerfile` provides the following build arguments.

| Name | Description |
| ---  | ---         |
| `endpoint` | See [CLI Access](https://portal.slateci.io/cli) and/or meeting notes for the development values. |
| `token` | See [CLI Access](https://portal.slateci.io/cli) and/or meeting notes for the development values. |
| `username` | The SLATE API username sent to Lincoln Bryant for integration with Puppet, SLATE, and the Bastion servers. |

## Setup

### Production

Build and run the Docker container for production.

```shell
docker build --file Dockerfile --build-arg endpoint=<prod-endpoint> --build-arg token=<prod-token> --build-arg username=<username> --tag slateci-client:prod .
```

```shell
docker run -it -v /<repo-location>/work:/work slateci-client:prod
```

### Development

Build and run the Docker container for development.

```shell
docker build --file Dockerfile --build-arg endpoint=<dev-endpoint> --build-arg token=<dev-token> --build-arg username=<username> --tag slateci-client:dev .
```

```shell
docker run -it -v /<repo-location>/work:/work slateci-client::dev
```

## SSH Commands

The `username` and SSH keys are already applied to the container in a standard way. Therefore, the once lengthy `ssh` commands may now be severely shortened. For example:

```shell
[username@1234 ~]$ ssh -J <username>@<bastion-hostname> <username>@<endpoint-hostname>
```

becomes:

```shell
[username@1234 ~]$ ssh -J <bastion-hostname> <endpoint-hostname>
```

