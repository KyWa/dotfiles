# RHV Installation

https://access.redhat.com to download a RHV ISO or the RHV-M appliance. This is the supported version of the oVirt project.

RHV cannot be run on RHEL 8 until at least RHV 4.4 (est 5/2020)

`hosted-engine --deploy` runs the installer, or can use the web-console at `https://<virtualhost>:9090` and then click on the HostedEngine tab. This is run from a newly setup node/host (RHEL or RHV-H).

Best practice is to install over cockpit/webconsole. This method can be slower than running hosted-engine, but is easier to do as you get visual queues.
