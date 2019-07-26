# Container Builds

## Dockerfile Syntax

The `FROM` instruction declares that the new container image extends rhel7:7.5 container base image. Dockerfiles can use any other container image as a base image, not only images from operating system distributions. Red Hat provides a set of container images that are certified and tested and highly recommends using these container images as a base.

The `LABEL` is responsible for adding generic metadata to an image. A LABEL is a simple key-value pair.

`MAINTAINER` indicates the Author field of the generated container image's metadata. You can use the podman inspect command to view image metadata.

`RUN` executes commands in a new layer on top of the current image. The shell that is used to execute commands is /bin/sh .

`EXPOSE` indicates that the container listens on the specified network port at runtime. The EXPOSE instruction defines metadata only; it does not make ports accessible from the host. The -p option in the podman run command exposes container ports from the host.

`ENV` is responsible for defining environment variables that are available in the container. You can declare multiple ENV instructions within the Dockerfile . You can use the env command inside the container to view each of the environment variables.

`ADD` instruction copies files or folders from a local or remote source and adds them to the container's file system. If used to copy local files, those must be in the working directory. ADD instruction unpacks local .tar files to the destination image directory.

`COPY` copies files from the working directory and adds them to the container's file system. It is not possible to copy a remote file using its URL with this Dockerfile instruction.

`USER` specifies the username or the UID to use when running the container image for the RUN , CMD , and ENTRYPOINT instructions. It is a good practice to define a different user other than root for security reasons.

`ENTRYPOINT` specifies the default command to execute when the image runs in a container. If omitted, the default ENTRYPOINT is /bin/sh -c .

`CMD` provides the default arguments for the ENTRYPOINT instruction. If the default ENTRYPOINT applies ( /bin/sh -c ), then CMD forms an executable command and parameters that run at container start.
