# Overview

Extends the `prom/alertmanager` image and includes `a8m/envsubst` to provide
environment substitation.

## Why?

Alertmanager does not provide an easy way to substitute secrets into its
configuration file.

Various receivers require credentials to authenticate. We want to commit alertmanager
configs to Git, but we don't want to commit the credentials (at least not in the same file).

## Usage

An example config and secrets file is provided in `./config`.

You are required to mount a volume `/config`

```
docker run -v $(pwd)/config:/config --env-file ./config/alertmanager.secrets mintel/docker-alertmanager
```

For Kubernetes, you can just mount your own `alertmanager.yml` to `/config/alertmanager-template.yml`.