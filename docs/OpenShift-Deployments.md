# Kubernetes / OpenShift Deployments

To look at which templates exist in an OpenShift clsuter run `oc get templates -n openshift` where `openshift` is the namespace you wish to view. To view detailed output of a specific tempalte you will run `oc get template <template-name> -n <namespace> -o yaml`.

## Example Deployments

*Delpyment with PersistenVolumeClaims*

```yaml
apiVersion: template.openshift.io/v1
kind: Template
labels:
  template: myapp-persistent-template
metadata:
  name: myapp-persistent
  namespace: openshift
objects:
- apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: ${APP_NAME}
  spec:
    accessModes:
    - ReadWriteOnce
    resources:
      requests:
        storage: ${VOLUME_CAPACITY}
- apiVersion: v1
  kind: DeploymentConfig
  metadata:
    name: ${APP_NAME}
  spec:
    replicas: 1
    selector:
      name: ${APP_NAME}
    strategy:
      type: Recreate
    template:
      metadata:
        labels:
          name: ${APP_NAME}
      spec:
        containers:
        - image: 'openshift/myapp'
          name: myapp
          volumeMounts:
          - mountPath: /var/lib/myapp/data
            name: ${APP_NAME}-data
        volumes:
        - name: ${APP_NAME}-data
          persistentVolumeClaim:
            claimName: ${APP_NAME}
parameters:
- description: The name for the myapp application.
  displayName: Application Name
  name: APP_NAME
  required: true
  value: myapp
- description: Volume space available for data, e.g. 512Mi, 2Gi.
  displayName: Volume Capacity
  name: VOLUME_CAPACITY
  required: true
  value: 1Gi
```
