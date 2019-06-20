# Powershell

## Move object to new OU
`$target = Get-ADOrganizationalUnit -LDAPFilter "(name=<OUNAME>)"`
`Get-ADComputer <COMPUTERNAME> | Move-ADObject -TargetPath $target.DistinguishedName`

## Sign a cert on CA
`Certreq -submit -attrib "CertificateTemplate:WebServer" "C:\certs\cert.csr"`

## Get Drive Mount Points
`gdr -PSProvider 'FileSystem'`
`net us`
