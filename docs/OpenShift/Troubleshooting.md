# OCP Troubleshooting


## Stuck ServiceInstance
Primarily an issue with OCP3

`oc edit serviceinstance <name> -n <namespace>`

remove these lines:

```
finalizers:
- kubernetes-incubator/service-catalog
```
