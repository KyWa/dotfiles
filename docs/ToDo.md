# ToDo

Build and deploy oVirt cluster. ($700 per host with 500GB storage each - 16vcpu 32GB). 3 Node cluster. Self-Hosted engine with 4GB ram. Can test hyperconverged (glusterfs).

Get new chassis for NAS. preferably 3U for better cooling support. Keeping existing hardware, just moving chassis to become rackmount. Will use raspberry Pis for odd-ball lab. Possibly docker-swarm, possibly individual web servers for testing things.

Test DNS, DHCP servers. Test LDAP (FreeIPA) servers for using with Gitlab and the soon to be new oVirt cluster. 


New Homelab should look like so


---------------     --------------      [ Containerized Workloads] 
| oVirt-node1 |     | OKD-master |  
| oVirt-node2 | - > | OKD-node1  |  - > Gitlab, Nextcloud, Ghost, kywa.io, Minecraft-server, Plex(Testing containerized)
| oVirt-node3 |     | OKD-node2  | 
---------------     --------------

--------------     
| STORINATOR |  - > (RAID 6: 8 drives) 22TB Array for Media, (RAID 1: 2 drives) 1TB Private Array
-------------- 
