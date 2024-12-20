# Ceph / ODF Commands

## General / Misc / Troubleshoot
### Change "fullness" ratios to allow functionality to debug
```sh
ceph osd set-nearfull-ratio .90
ceph osd set-backfillfull-ratio .95
ceph osd set-full-ratio .97

ceph osd set-nearfull-ratio .85
ceph osd set-backfillfull-ratio .90
ceph osd set-full-ratio .95
```

### Add OSDs and/or Move OSDs
```sh
# Create new bucket/rack
ceph osd crush add-bucket rack2 rack

# Move bucket/rack to main cluster
ceph osd crush move rack2 root=default

# Move OSD under new rack
ceph osd crush move osd-host/disk rack=rack2
ceph osd crush move osd-host/disk rack=rack2
```


## NooBaa
### How to reinstall NooBaa
```sh
oc patch -n openshift-storage noobaa noobaa --type='merge' -p '{"spec":{"cleanupPolicy":{"allowNoobaaDeletion":true}}}'
oc patch -n openshift-storage noobaas/noobaa --type=merge -p '{"metadata": {"finalizers":null}}'
oc delete -n openshift-storage noobaas.noobaa.io  --all
```

### Bucket info
```sh
radosgw-admin bucket list 
radosgw-admin bucket stats 
```

### Get all objects in pool
```sh
rados -p ocs-storagecluster-cephobjectstore.rgw.buckets.data ls
```

### Delete buckets
```sh
radosgw-admin bucket rm --bucket=BUCKET_NAME --purge-objects --bypass-gc
```

### Faster deletion of objects
```sh
rados -p ocs-storagecluster-cephobjectstore.rgw.buckets.data ls | grep SOME_OBJECT_TO_SEARCH_FOR | xargs -d '\n' -n 200 rados -p ocs-storagecluster-cephobjectstore.rgw.buckets.data rm
```

## VolumeSnapshots
### Cleanup Failed Clones
```sh
ceph fs subvolume ls ocs-storagecluster-cephfilesystem csi --format json | jq '.[] | .name' | cut -f 2 -d '"' > /tmp/subvolumes
for i in `cat /tmp/subvolumes`;do ceph fs subvolume info --group-name=csi ocs-storagecluster-cephfilesystem $i --format=json >> /tmp/info;done
for i in `cat /tmp/info | jq -r 'select(.type ==  "clone") .path' | cut -d "/" -f 4`;do ceph fs subvolume rm ocs-storagecluster-cephfilesystem --group-name csi $i;done
```

### Cancel all clones
```sh
for i in `ceph fs subvolume ls ocs-storagecluster-cephfilesystem csi --format json | jq '.[] | .name' | cut -f 2 -d '"'`; do echo "Subvolume : $i"; ceph fs clone cancel ocs-storagecluster-cephfilesystem $i csi; done
```

### Query all clones
```sh
for i in `ceph fs subvolume ls ocs-storagecluster-cephfilesystem csi --format json | jq '.[] | .name' | cut -f 2 -d '"'`; do echo "Subvolume : $i"; ceph fs clone status ocs-storagecluster-cephfilesystem $i csi; done
```

### Delete Clone
```sh
ceph fs clone rm ocs-storagecluster-cephfilesystem <subvolume-name> csi
```

### Delete subvolumes / snapshots
```sh
ceph fs subvolume snapshot rm ocs-storagecluster-cephfilesystem --group-name csi csi-vol-63f2602e-65a8-4b59-bf64-631cb7fa4f57 csi-snap-0286a608-c0c2-47d3-9c3d-01cdc265cab9
```

```sh
for i in `ceph fs subvolume ls ocs-storagecluster-cephfilesystem csi --format json | jq '.[] | .name' | cut -f 2 -d '"'`;do ceph fs subvolume info --group-name csi ocs-storagecluster-cephfilesystem $i --format=json 2> /tmp/to_be_deleted; done
for i in `cat /tmp/to_be_deleted | awk '{print $4}'`;do echo "Deleteing $i";ceph fs subvolume rm ocs-storagecluster-cephfilesystem --group-name csi $i --force; done
```

### List all CephFS Snapshots
```sh
for i in `ceph fs subvolume ls ocs-storagecluster-cephfilesystem csi --format json | jq '.[] | .name' | cut -f 2 -d '"'`; do echo "Subvolume : $i"; ceph fs subvolume snapshot ls ocs-storagecluster-cephfilesystem $i csi; done
```

### Find CephFS Volume Snapshots that can be deleted
```sh
for subvolume in $(ceph fs subvolume ls ocs-storagecluster-cephfilesystem --group_name csi | jq -r '.[].name'); do for snap in $(ceph fs subvolume snapshot ls ocs-storagecluster-cephfilesystem ${subvolume} --group_name csi|jq -r '.[].name'); do echo ${subvolume} ${snap} ; ceph fs subvolume snapshot info ocs-storagecluster-cephfilesystem ${subvolume} ${snap} --group_name csi  ; done; done > /tmp/cephfs_snap_info_all.txt
```
