# OpenShift ControlPlane

* etcd
* Scheduler
* API

## Master Service (dump of content to be fixed)
OCP api server has api calls unique to ocp
OLM = Operator Lifecycle Manager
    * ota updates of operators for workloads etc..
All api requets ssl-encrypted and authenticated
Authorizations handled via rbac
All users access OCP through same standard interfaces
    * wbui, cli, ides all go through authenticated rbac-controlled api
Pods that fail too often marked as bad and temporarily not restarted
    * Service layer sends traffic only to healthy pods

## etcd

Split between control plane nodes. Desired and current state data is held in data stores that uses `etcd` as its distributed key-value store. Also contains RBAC rules, app env info, non-app user data etc.

## Scheduler

OCP4 is able to use real-world topology for cluster deployments such as using regions and availability zones for placing workers. Uses configuraiton in combination with nodegreoups and labels to place nodes. Can be configured to scale infrastructure automatically.
