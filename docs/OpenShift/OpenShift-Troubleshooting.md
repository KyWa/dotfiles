# OpenShift Troubleshooting

If RHOCP was installed via RPM you have some tools to assist such as `sosreport`. This can generate logs that are needed for Red Hat Support to view what happaned and assist in troubleshooting. Example:

* `sosreport -k docker.all=on -k docker.logs=on` - This creates a compressed archive with all relevant info and saves it in a compressed archive in /var/tmp which can be sent to Red Hat Support.

`oc get events` is helpful when needing to view what is currently happening in the cluster. If there is a certain project you are concerned with, pass the `-n <project>` flag with it to view events that only pertain to that project.

`oc logs` will always be handy. You can specify the `bc`, `pod`, `dc` and others and supporst `-f` to follow like `tail`.

`oc rsync` can be used to copy logs from inside a container to review. Examples:

* `os rsync <pod>:<pod_dir> <local_dir> -c <container>` - Transfers from a pod to a local directory specifying which container (without the `-c` it chooses the first container in a pod)
* `os rsync <local_dir> <pod>:<pod_dir> -c <container>` - Transfers from a local directory to a pod (again specifying the container)

## Troubleshooting Common Issues

*Resource Limits and Quota Issues*

For projects that have resource limits and quotas set, the improper configuration of resources will cause deployment failures. Use the oc get events and oc describe commands to investigate the cause of the failure. For example, if you try to create more pods than is allowed in a project with quota restrictions on pod count, you will see the following output when you run the oc get events command:
```
14m
Warning  FailedCreate  {hello-1-deploy} Error creating: pods "hello-1" is forbidden:
exceeded quota: project-quota, requested: cpu=250m, used: cpu=750m, limited: cpu=900m
```

*Source-to-Image (S2I) Build Failures*

Use the oc logs command to view S2I build failures. For example, to view logs for a build configuration named hello:
```
[user@workstation ~]$oc logs bc/hello
```

You can adjust the verbosity of build logs by specifying a `BUILD_LOGLEVEL` environment variable in the build configuration strategy, for example:

```json
{
  "sourceStrategy": {
    ...
    "env": [
      {
        "name": "BUILD_LOGLEVEL",
        "value": "5"
      }
    ]
  }
}
```

*ErrImagePull and ImgPullBackOff Errors*

These errors are caused by an incorrect deployment configuration, wrong or missing images being referenced during deployment, or improper Docker configuration. For example:
```
Pod  Warning   FailedSync   {kubelet node1.lab.example.com}
Error syncing pod, skipping: failed to "StartContainer" for "pod-diagnostics" with ErrImagePull: "image pull failed for registry.access.redhat.com/openshift3/ose-deployer:v3.5.5.8..."
...
Pod       spec.containers{pod-diagnostics}   Normal    BackOff {kubelet node1.lab.example.com}   Back-off pulling image "registry.access.redhat.com/openshift3/ose-deployer:v3.5.5.8"
...
pod-diagnostic-test-27zqb   Pod  Warning   FailedSync   {kubelet node1.lab.example.com}
Error syncing pod, skipping: failed to "StartContainer" for "pod-diagnostics" with ImagePullBackOff: "Back-off pulling image \"registry.access.redhat.com/openshift3/ose-deployer:v3.5.5.8\""
```

Use the oc get events and oc describe commands to check for details. Fix deployment configuration errors by editing the deployment configuration using the oc edit dc/<deploymentconfig> command.

*Incorrect Docker Configuration*

Incorrect docker configuration on masters and nodes can cause many errors during deployment. Specifically, check the `ADD_REGISTRY`, `INSECURE_REGISTRY`, and `BLOCK_REGISTRY` settings and ensure that they are valid. Use the `systemctl status`, `oc logs`, `oc get events`, and `oc describe` commands to troubleshoot the issue.

You can change the docker service log levels by adding the `--log-level` parameter for the `OPTIONS` variable in the docker configuration file located at `/etc/sysconfig/docker`. For example, to set the log level to debug:

`OPTIONS='--insecure-registry=172.30.0.0/16 --selinux-enabled --log-level=debug'`

*Master and Node Service Failures*

Run the `systemctl status` command for troubleshooting issues with the `atomic-openshift-master`, `atomic-openshift-node`, `etcd`, and `docker` services. Use the `journalctl -u <unit-name>` command to view the system log for issues related to the previously listed services.

You can increase the verbosity of logging from the `atomic-openshift-node`, the `atomic-openshift-master-controllers`, and `atomic-openshift-master-api` services by editing the `--loglevel` variable in the respective configuration files, and then restarting the associated service.

For example, to set the OpenShift master controller log level to debug, edit the following line in the `/etc/sysconfig/atomic-openshift-master-controllers` file:

`OPTIONS=--loglevel=4 --listen=https://0.0.0.0:8444`

    ### NOTE
    Red Hat OpenShift Container Platform has five numbered log message severities. Messages with FATAL, ERROR, WARNING, and some INFO severities appear in the logs regardless of the log configuration. The severity levels are listed below:
    * 0 - Errors and warnings only
    * 2 - Normal information (default)
    * 4 - Debugging-level information
    * 6 - API-level debugging information (request/response)
    * 8 - API Debugging information with full body of request

    Similarly, the log level for OpenShift nodes can be changed in the `/etc/sysconfig/atomic-openshift-node` file.
    
*Failures in Scheduling Pods*

The OpenShift master schedules pods to run on nodes. Sometimes, pods cannot run due to issues with the nodes themselves not being in a Ready state, and also due to resource limits and quotas. Use the `oc get nodes` command to verify the status of nodes. During scheduling failures, pods will be in the `Pending` state, and you can check this using the `oc get pods -o wide` command, which also shows the node on which the pod was scheduled to run. Check details about the scheduling failure using the `oc get events` and `oc describe pod` commands.

A sample pod scheduling failure due to insufficient CPU is show below from `oc describe`:
```
{default-scheduler }  Warning  FailedScheduling pod (FIXEDhello-phb4j) failed to fit in any node
fit failure on node (hello-wx0s): Insufficient cpu
fit failure on node (hello-tgfm): Insufficient cpu
fit failure on node (hello-qwds): Insufficient cpu
```
A pod failing because of no nodes in a `Ready` state.
```
{default-scheduler }  Warning  FailedScheduling pod (hello-phb4j): no nodes available to schedule pods
```
