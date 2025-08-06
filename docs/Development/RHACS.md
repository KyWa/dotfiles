# Red Hat Advanced Cluster Security

## Policy enforcement bug
When testing some policies, it was noticed that if arguments are set prior to the "catch" of the policy, it will not get flagged and as a result, not be enforced. Below are some snippets of the `collector` container logs:
```
[DEBUG   2025/08/06 15:05:05] (ProcessSignalFormatter.cpp:192) Process (2c148dcc473c: 2348364): curl[]  (/usr/bin/curl) -v -k -sL https://10.0.0.1:10250/healthz
[DEBUG   2025/08/06 15:05:22] (ProcessSignalFormatter.cpp:192) Process (2c148dcc473c: 2350521): curl[]  (/usr/bin/curl) https://10.0.0.1:10250/healthz
[DEBUG   2025/08/06 15:09:04] (ProcessSignalFormatter.cpp:192) Process (53a602680460: 2371879): curl[]  (/usr/bin/curl) https://10.0.0.1:10250/healthz -v -k -sL
```
