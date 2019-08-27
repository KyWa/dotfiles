# Virtual Machines

#### Supported Operating Systems

| Operating System             | Version                                    |
| ---                          | ---                                        |
| Red Hat Enterprise Linux     | 3, 4, 5, 6, 7, 8                           |
| Microsoft Windows Server     | 2008, 2008 (R2), 2012, 2012 R2, 2016, 2019 |
| Microsoft Windows            | 7, 8, 8.1, 10                              |
| SUSE Linux Enterprise Server | 10, 11, 12, 15                             |

Instance Type Configuration

#### Desktop

* Enable all USB devices
* Enable the Smart Card device
* Use an Image with Thin Allocation
* Instance is Stateless

#### Server

* Disable the Sound Card device
* Use a Cloned Disk Image
* Instance is Not Stateless

#### HPC (High Performance Compute)

* Enable Headless Mode and enable Serial console
* Disable all USB devices
* Disable the Sound Card device
* Disable the Smart Card device
* Enable Pass-Through Host CPU
* Disable VM migration
* Enable IO Threads, Num Of IO Threads = 1
* Disable the Memory Balloon Device
* Enable High availability only for pinned hosts
* Disable the Watchdog device
* Enable paravirtualized Random Number Generator PCI (virtio-rng) device
* Enable Multi Queues per Virtual Interface
* Set the IO and Emulator threads pinning topology
