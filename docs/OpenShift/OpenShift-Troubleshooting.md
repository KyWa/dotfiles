# OCP Troubleshooting

## Stuck ServiceInstance

`oc edit serviceinstance <name> -n <namespace>`

remove these lines:

```
finalizers:
- kubernetes-incubator/service-catalog
```
