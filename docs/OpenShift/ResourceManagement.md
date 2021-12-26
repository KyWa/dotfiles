# OpenShift Resource Management

## Limits

Limits can include:
* number of objects created in project
* amount of resources (c/m/s) requested across objects in project
* based on specified label
    * ex: limit dept of devs or env such as `test`
    * 
## Quotas

ResourceQuota object enumerates hard resource usage limits per project
ClusterResourceQuota object enumerates hard resource usage limits for users across the cluster (could be used in cloud to keep costs down if auto infra scaling is enabled)

## LimitRanges

LimitRanges:
* express cpu and mem requirments of pods containers
* set request and limit of cpu/mem particular pods may consume
* aids scheduler in assigning pods to nodes
* has service tiers: Best Effort, Burstable, Guaranteed
* default LimitRange for all pods/containres can be set for each project

## QOS

BestEffort:  applied when container requests and limits not defined
* cpu = uses as much as possible but at lowest prio
* mem = uses as much as possible, no guaranteed minimum, highest prio to terminato to free up host mem
Burstable: applied when container requests defined but limits not defined or higher than requested
* cpu = container guarnateed min requestsed amount of cpu, can use more at lower prio
* mem = minimum requested guaranteed, can use as much as available, terminated after besteffort containers to free up host mem
Guaranteed: applied when container requests and limits defined with same value
* cpu = container guaranteed and limited to specified amount and cannot exceed
* mem = guaranteed and limited to specify amount, terminated if exceeds amount
