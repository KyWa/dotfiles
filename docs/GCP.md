# GCP Training 3/27/19

Base groups: Org, Network, Security, Billing

Automatic sustained use discounts (if the instance runs the full month its cost is reduced by 30% with decreasing discounts the less its used)

VPCs are global, subnets are regional. Firewalls are enforced at the host. Defined in the subnet.

VPN/Interconnect/Direct Peering for connectivity options.

# GCP Bootcamp 4/8/2019

Structural Layout: {Organization: {Folder: {Projects: Resources}}}

Access is given based on roles. Google Accounts or Cloud Identity user, Service Account, Google Group, Cloud Identity (GSuite Domain). Higher tier permissions cannot be changed on lower objects. Example: Project Admin cannot be restricted on any object below the project.
