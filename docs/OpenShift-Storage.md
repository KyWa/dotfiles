# Kubernetes / OpenShift Storage

`PersistentVolumes` can be seen via an `oc get pv` call. To create a `PersistentVolume` you need a basic config to apply via `oc create -f file.yml`. Example of a `PersistentVolumeClaime` below:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: myapp
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

Then you can update your deployment/template with the volumes section as outlined below:

```yaml
apiVersion: "v1"
kind: "Pod"
metadata:
  name: "myapp"
  labels:
    name: "myapp"
spec:
  containers:
    - name: "myapp"
      image: openshift/myapp
      ports:
        - containerPort: 80
          name: "http-server"
      volumeMounts:
        - mountPath: "/var/www/html"
          name: "pvol" 
  volumes:
    - name: "pvol" 
      persistentVolumeClaim:
        claimName: "myapp"
```
