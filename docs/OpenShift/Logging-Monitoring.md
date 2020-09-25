# OpenShift Logging and Monitoring

## Logging

The logging stack is mostly unchanged from OCP3. Still the EFK stack but now deployed as an Operator with obviously newer versions of the underlying software.

Cluster Admins can view all logs in Kibana. Developers can only view logs for projects they have access and permission in.

## Monitoring

Monitoring comes pre-installed as an Operator. The stack involves Prometheus and Grafana and most configuration happens post cluster install.

TODO

## Metrics

TODO
