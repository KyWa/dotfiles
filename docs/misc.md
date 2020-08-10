# Misc

## OKD Homelab with Centos 7.8
Certs for registry.access.redhat.com do not get deployed. Get them via:
`openssl s_client -showcerts -servername registry.access.redhat.com -connect registry.access.redhat.com:443 </dev/null 2>/dev/null | openssl x509 -text > /etc/rhsm/ca/redhat-uep.pem`
