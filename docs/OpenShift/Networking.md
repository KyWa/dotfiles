# OpenShift Networking

## Routers

Provides automated load balancing to pods for external clients. Routers (and the actual Routes) can autoroute around unhealthy pods. The routing layer is pluggable and extensible. Can include non-OpenShift software routers.

### Route

A Route exposes a `service` by giving it an externally reachable hostname. A Route consists of a route name, service selector and optional security config. A router can consume defined Route and endpoints identified by a `service`.
