# ConfigMaps and Secrets

## Secrets

The Secret object type provides a mechanism to hold sensitive information such as passwords, OpenShift Container Platform client configuration files, Docker configuration files, and private source repository credentials. Secrets decouple sensitive content from pods. You can mount secrets onto containers using a volume plug-in or the system can use secrets to perform actions on behalf of a pod.

### Features of Secrets

* Secret data can be referenced independently from its definition.
* Secret data volumes are backed by temporary file storage.
* Secret data can be shared within a namespace.

A secret is created before the pods that depend on that secret. Steps to creating and using a secret are:

1. Create a secret object with secret data
2. Update the pod's service account to allow the reference to the secret
3. Create a pod that consumes the secret as an environment variable or as a file using a data volume

### How Secrets are exposed to pods

Secrets can be mounted as data volumes or exposed as environment variables to be used by a container in a pod. For example, to exposea secrete to a pod, first create a secret and assign alues such as a username and password to key/value pairs, then assign the key name to the pod's YAML file env definition. Take a secret named `demo-secret`, that defines the key `username` and set the key's value to the user `demo-user`:

`oc create secret generic demo-secret --from-literal=username=demo-user`

To use the previous secret as the database administrator password for a MySQL pod, define the env variable with a reference to the secret name and the key:

```yaml
env:
  - name: MYSQL_ROOT_PASSWORD
    valueFrom:
      secretKeyRef:
        key: username
        name: demo-secret
```

### Use Cases for Secrets

#### Passwords and Usernames

Sensitive Information, such as passwords and usernames, can be stored in a secret that is mounted as a data volume in a container. The data appears as content in files located in the data volume directory of the container. An application, such as a database, can then use these secrets to authenticate users.

#### TLS and Key Pairs

Securing communication to a service can be accomplished by having the cluster generate a signed certificate and key pair into a secret within the project's namespace. The certificate and key pair are stored using PEM format, in files such as `tls.crt` and `tls.key`, located in the secret's data volume of the pod.

## ConfigMap Objects

ConfigMaps objects are similar to secrets, but are designed to support the ability to work with strings that do not contain senstive information. The ConfigMap object holds key-value pairs of configuration data that can be consumed in pods or used to store configuration data for system components such as controllers.

The `ConfigMap` object provides a mechanism to inject configuration data into containers. `ConfigMap` store granular info such as individual properties, or detailed information, such as entire configuratino files or JSON blobs.

#### Creating ConfigMap from the CLI

A ConfigMap object can be created from literal values using the `--from-literal` option. The following command creates a ConfigMap object that assigns the IP address `172.20.30.40` to the ConfigMap key named `serverAddress`:

`oc create configmap special-config --from-literal=serverAddress=172.20.30.40`

Use the following to view the configMap:

`oc get configmaps special-config -o yaml`

*Output*
```yaml
apiVersion: v1
data:
  key1: serverAddress=172.20.30.40
kind: ConfigMap
metadata:
  creationTimestamp: 2017-07-10T17:13:31Z
  name: special-config
  namespace: secure-review
  resourceVersion: "93841"
  selfLink: /api/v1/namespaces/secure-review/configmaps/special-config
  uid: 19418d5f-6593-11e7-a221-52540000fa0a
```

*Applying configMap in definition file*
```yaml
env:
  - name: APISERVER
     valueFrom:
        configMapKeyRef:
            name: special-config
            key: serverAddress
```
