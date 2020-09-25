# Application Development on OpenShift

CI Best Practices:
* Maintain code repository
* Automate build
* Make build self-testing
* Make sure everyone commits every day
* Keep build fast
* Test in production clone
* Make getting deliverables easy
* Make sure everyone can view build results

## dump to be sorted later

probes: run by kubelet
readiness = is it ready to recieve requests
liveness = is it still actually working
    - http: check for return code
    - sh: run command in container
    - socket: checks to see if socket can be opened
metadata.ownerReferences = see which object owns object
`oc explain ref` = get detailed info about objects. can add to `pod.spec.containers.readinessProbe

blue/green (in route):
spec:
  host: bluegreen-55bb-bluegreen.apps.shared-na4.na4.openshift.opentlc.com
  port:
    targetPort: 8080-tcp
  subdomain: ""
  to:
    kind: Service
    name: green
    weight: 50
  alternateBackends:
  - kind: Service
    name: blue
    weight: 50

canary (in route):
spec:
  alternateBackends:
  - kind: Service
    name: blue
    weight: 1
  host: bluegreen-55bb-bluegreen.apps.shared-na4.na4.openshift.opentlc.com
  port:
    targetPort: 8080-tcp
  subdomain: ""
  to:
    kind: Service
    name: green
    weight: 9
