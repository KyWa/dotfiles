# VMware

    ### NOTE
    All of these items were from VMWare ESXi 5.5 and not known to work on any other version

## View inventory
`vim-cmd vmsvc/getallvms`

## Backup inventory file
`cd /etc/vmware/hostd`
`cp vmInventory.xml vmInventory.xml.bak`

## Stop inventory services
`/etc/init.d/vpxa stop`
`/etc/init.d/hostd stop`

## Move inventory file
`mv vmInventory.xml vmInventory_xml.bak`

## Restart services
`/etc/init.d/vpxa start`
`/etc/init.d/hostd start`
`for i in `find /vmfs/volumes/ | grep ".vmx" | grep -v vmxf | grep -v vswp | grep -v ".bak"`;do vim-cmd solo/registervm $i;done`
