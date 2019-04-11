# Overview

Extends the `prom/alertmanager` image and includes `a8m/envsubst` to provide
environment substitation.

This is intended to be used with https://github.com/coreos/prometheus-operator (hence it's Kubernetes specific).

## Why?

Alertmanager does not provide an easy way to substitute secrets into its
configuration file.

Various receivers require credentials to authenticate. We want to commit alertmanager
configs to Git, but we don't want to commit the credentials (at least not in the same file).

## Usage

The Alertmanager CRD supports mounting of both `secrets` and `configmaps`.

>  configMaps:
   ConfigMaps is a list of ConfigMaps in the same namespace
   as the Alertmanager object, which shall be mounted into the Alertmanager
   Pods. The ConfigMaps are mounted into /etc/alertmanager/configmaps/<configmap-name>.

>  secrets:
   Secrets is a list of Secrets in the same namespace as the
   Alertmanager object, which shall be mounted into the Alertmanager
   Pods. The Secrets are mounted into /etc/alertmanager/secrets/<secret-name>.


### Create a configmap

You must create a `ConfigMap` named `alertmanager` containing the config to be templated.

This must be added to the `configMaps` option in the CRD.

### Create 1 or more secrets

You must create 1 or more secrets and add them to the `secrets` option in the CRD.

Example:

```
kubectl create secret generic alertmanager \
 --from-literal=TEAM_DB_API_KEY=foo \
 --from-literal=TEAM_X_API_KEY=foo \
 --from-literal=TEAM_Y_API_KEY=foo --dry-run -o yaml
```

You can test this locally with the example `./configmaps` and `./secrets` directories in this repo.


## Local testing
```
docker run \
    -v $(pwd)/configmaps:/etc/alertmanager/configmaps \
    -v $(pwd)/secrets:/etc/alertmanager/secrets
    mintel/docker-alertmanager

```