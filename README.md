# slateci-client-access

> **_NOTE:_** This repository requires a read-through of [CLI Access](https://portal.slateci.io/cli) in order to make any sense.

Containerized SLATE CLI access.

## Arguments

The `Dockerfile` provides the following build arguments.

| Name | Description |
| ---  | ---         |
| `endpoint` | See [CLI Access](https://portal.slateci.io/cli) and/or meeting notes for the development values. |
| `token` | See [CLI Access](https://portal.slateci.io/cli) and/or meeting notes for the development values. |

## Setup

### Production

Build and run the Docker container for production.

```shell
docker build --file Dockerfile --build-arg endpoint=<prod-endpoint> --build-arg token=<prod-token> --tag slateci-client:prod .
```

```shell
docker run -it slateci-client:prod
```

### Development

Build and run the Docker container for development.

```shell
docker build --file Dockerfile --build-arg endpoint=<dev-endpoint> --build-arg token=<dev-token> --tag slateci-client:dev .
```

```shell
docker run -it slateci-client:dev
```