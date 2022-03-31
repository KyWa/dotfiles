# Misc

## OKD Homelab with Centos 7.8
Certs for registry.access.redhat.com do not get deployed. Get them via:
`openssl s_client -showcerts -servername registry.access.redhat.com -connect registry.access.redhat.com:443 </dev/null 2>/dev/null | openssl x509 -text > /etc/rhsm/ca/redhat-uep.pem`

## Mac DNS failure on single host
`sudo killall -HUP mDNSResponder`

## Synology NFS for oVirt
Share must have `36:36` permissions

## Ghost Blog

### Update Ghost
`cd /var/www/ghost && ghost update`

### Backup Ghost
`cd /var/www/ghost && ghost export /mnt/volume_nyc1_01/ghost_backup/blog-export-$(date "+%Y-%m-%d")`

## Asciicinema
Record Something:
`asciinema rec -i 2.5 ~/Pictures/blog-media/mineOps/NAME_OF_CLIP.cast`

Convert it to gif:
`docker run --rm -v $PWD:/data asciinema/asciicast2gif -s 2 NAME_OF_CLIP.cast GIF.gif`
