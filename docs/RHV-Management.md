# RHV Management

Self-Hosted engine runs on a single node. Currently no knowledge of making HA (outside of failover).

Cluster has migration management settings. The cluster can be configured to have auto migration of VMs (if load is to high in a single host) and load balance the VMs across the cluster. These settings can be found in Compute > Cluster EDIT > Migration Policy/Scheduling Policy. 
