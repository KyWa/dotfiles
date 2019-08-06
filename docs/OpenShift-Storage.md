# Kubernetes / OpenShift Storage

In OpenShift to allow storage from the host to a container/pod you must modify the SELinux configuration via: `semanage fcontext -a -t container_file_t '/path/to/data(/.*)?'`. Don't forget to apply them via `restorecon -Rv /path/to/data`.

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
