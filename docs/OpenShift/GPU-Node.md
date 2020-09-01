# GPU Node

In this document I will go over the steps and items needed to get Nvidia Drivers installed and working for container workloads with Podman. All links will be at the bottom of this document for reference.

## Drivers and CUDA

Obviously the first required portion of running any GPU enabled workload is drivers for the GPU itself. This will almost always consist of Nvidia Drivers and CUDA. The repository for these items can be found [here](https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64) at Nvidia's Developer website.

>    ### NOTE
>    Nvidia has changed the name of some packages throughout their iterations. These are the current package names at the time of this writing. This is also written for RHEL 8. RHEL 7 is still supported and there is documentation that exists for it. RHEL 8 is similar, but uses different methods of package installation and what is focused on here.
    
### Packages

NVIDIA drivers need to be compiled for the kernel in use. The build process requires the `kernel-devel` package to be installed.

```sh
[root@rhel8]: dnf -y install kernel-devel-`uname -r` kernel-headers-`uname -r`
```

To install the required Nvidia drivers and packages use the commands below (this requires going to the [link](https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64) above in the Drivers and CUDA section):

```sh
[root@rhel8]: dnf -y module install nvidia-driver:latest-dkms
[root@rhel8]: dnf -y install cuda
```

The `nouveau` driver will need to be blacklisted for the Nvidia drivers to work. The Nvidia packages will handle this for subsequent reboots by blacklisting the driver in the kernel command line. To blacklist it yourself without requireing a reboot, run the following:

```sh
[root@rhel8]: modprobe -r nouveau
```

Load the NVIDIA and the unified memory kernel modules.

```sh
[root@rhel8]: nvidia-modprobe && nvidia-modprobe -u
```


## Runtimes

For RHEL 8, Docker is not included and not supported by Red Hat (although it is still available from other sources). As OpenShift 4 no longer uses Docker in favor of CRI-O, this will be covered using [Podman](https://podman.io/) and [CRI O](https://cri-o.io/). For more information on CRI-O this [blog](https://www.redhat.com/en/blog/introducing-cri-o-10) post should cover most of the questions.

```sh
[root@rhel8]: dnf -y install podman
```

This will install `podman` on your host. This tool is what we will be using to run containers.

>    ### NOTE
>    For the full container tools on RHEL 8, you will need to install their module like so:
>    
>    `[root@rhel8]: dnf -y module install nvidia-driver:latest-dkms`
>    
>    This module will net you `podman`, `buildah`, and `skopeo`. The other 2 tools mentioned here, [buidah](https://buildah.io/) and [skopeo](https://github.com/containers/skopeo), are tools that replace functionality from the monolith that was Docker. They will not be the focus today, but are worth checking out in their own right.

### OCI Runtime Hooks
    
Podman includes support for OCI runtime hooks for configuring custom actions related to the lifecycle of the container. OCI hooks allow users to specify programs to run at various stages in the container lifecycle. Because of this, we only need to install the nvidia-container-toolkit package. This can be found [here](https://github.com/NVIDIA/nvidia-docker). There is a litle bit of manual setup with this compared to the Nvidia Drivers and CUDA. 

>    ### NOTE
>    If attempting to add this repo on something other than RHEL, Nvidia is using the same repo file for nearly all RHEL based distributions. The repo file used is below and can be saved under `/etc/yum.repos.d/nvidia-docker.repo`:
>    
>    [libnvidia-container]
>    name=libnvidia-container
>    baseurl=https://nvidia.github.io/libnvidia-container/centos7/$basearch
>    repo_gpgcheck=1
>    gpgcheck=0
>    enabled=1
>    gpgkey=https://nvidia.github.io/libnvidia-container/gpgkey
>    sslverify=1
>    sslcacert=/etc/pki/tls/certs/ca-bundle.crt
>    
>    [nvidia-container-runtime]
>    name=nvidia-container-runtime
>    baseurl=https://nvidia.github.io/nvidia-container-runtime/centos7/$basearch
>    repo_gpgcheck=1
>    gpgcheck=0
>    enabled=1
>    gpgkey=https://nvidia.github.io/nvidia-container-runtime/gpgkey
>    sslverify=1
>    sslcacert=/etc/pki/tls/certs/ca-bundle.crt
>    
>    [nvidia-docker]
>    name=nvidia-docker
>    baseurl=https://nvidia.github.io/nvidia-docker/centos7/$basearch
>    repo_gpgcheck=1
>    gpgcheck=0
>    enabled=1
>    gpgkey=https://nvidia.github.io/nvidia-docker/gpgkey
>    sslverify=1
>    sslcacert=/etc/pki/tls/certs/ca-bundle.crt

To add the repository for your RPM based distribution run the following:

```sh
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
[root@rhel8]: curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.repo | tee /etc/yum.repos.d/nvidia-docker.repo
```

This step will get the needed repositories installed onto your machine. As you can see there are 3 separate repositories. The next step will be to install the `nvidia-container-toolkit`. The prestart hook is responsible for making NVIDIA libraries and binaries available in a container (by bind-mounting them in from the host). 

```sh
[root@rhel8]: dnf install -y nvidia-container-toolkit
```
When this has completed, you should be able to run a container and test its functionality. For this first test (to make sure all the pegs are in the right holes), we will be testing as `root`. After this test is successful we will install an SELinux module and setup the system to use SELinux to allow Users to run GPU containers. For this first test, we will run it like so:

```sh
[root@rhel8]: podman run --privileged docker.io/mirrorgooglecontainers/cuda-vector-add:v0.1
[Vector addition of 50000 elements]
Copy input data from the host memory to the CUDA device
CUDA kernel launch with 196 blocks of 256 threads
Copy output data from the CUDA device to the host memory
Test PASSED
Done
```

The expected output should be the above. At the bottom of this document are "alternative" outputs and what to look for to resolve them.

## Considerations

If wanting to run GPU containers under a mortal user account, there is some extra steps needed and are outlined below.

### SELinux Policy Module

A ton of work went into getting this SELinux policy module built. The Git repo can be found [here](https://github.com/NVIDIA/dgx-selinux). With this repository you can compile it yourself or download the pre-compiled module for x86_64 based architectures (which should encompass most use-cases).

```sh
[root@rhel8]: wget https://raw.githubusercontent.com/NVIDIA/dgx-selinux/master/bin/RHEL7/nvidia-container.pp
[root@rhel8]: semodule -i nvidia-container.pp
```
This will download the pre-compiled module and install it. Once it has been successfully installed, we need to ensure that the host has the correct labels applied. Thankfully there is a quick and easy way to accomplish this. 

```sh
# Gets a list from Nvidia of all the items it uses and the passes them to have their contexts set
[root@rhel8]: nvidia-container-cli -k list | restorecon -v -f -
# The Nvidia GPU and assoicated items are located in /dev as device files
# Also needing their contexts set
[root@rhel8]: restorecon -Rv /dev
```
Whis this accomplished we should be able to run a GPU container as a mortal user. The command is similar to the one run previously, but there are a few options needed to be applied to it.

```sh
[user@rhel8]: podman run --user 1000:1000 --security-opt=no-new-privileges --cap-drop=ALL --security-opt label=type:nvidia_container_t docker.io/mirrorgooglecontainers/cuda-vector-add:v0.1
[Vector addition of 50000 elements]
Copy input data from the host memory to the CUDA device
CUDA kernel launch with 196 blocks of 256 threads
Copy output data from the CUDA device to the host memory
Test PASSED
Done
```

## Troubleshooting and Links

#TODO
