# Container Builds

## Dockerfile Syntax

* The `FROM` instruction declares that the new container image extends rhel7:7.5 container base image. Dockerfiles can use any other container image as a base image, not only images from operating system distributions. Red Hat provides a set of container images that are certified and tested and highly recommends using these container images as a base.
* The `LABEL` is responsible for adding generic metadata to an image. A LABEL is a simple key-value pair.
* `MAINTAINER` indicates the Author field of the generated container image's metadata. You can use the podman inspect command to view image metadata.
* `RUN` executes commands in a new layer on top of the current image. The shell that is used to execute commands is /bin/sh .
* `EXPOSE` indicates that the container listens on the specified network port at runtime. The EXPOSE instruction defines metadata only; it does not make ports accessible from the host. The -p option in the podman run command exposes container ports from the host.
* `ENV` is responsible for defining environment variables that are available in the container. You can declare multiple ENV instructions within the Dockerfile . You can use the env command inside the container to view each of the environment variables.
* `ADD` instruction copies files or folders from a local or remote source and adds them to the container's file system. If used to copy local files, those must be in the working directory. ADD instruction unpacks local .tar files to the destination image directory.
* `COPY` copies files from the working directory and adds them to the container's file system. It is not possible to copy a remote file using its URL with this Dockerfile instruction.
* `USER` specifies the username or the UID to use when running the container image for the RUN , CMD , and ENTRYPOINT instructions. It is a good practice to define a different user other than root for security reasons.
* `ENTRYPOINT` specifies the default command to execute when the image runs in a container. If omitted, the default ENTRYPOINT is /bin/sh -c .
* `CMD` provides the default arguments for the ENTRYPOINT instruction. If the default ENTRYPOINT applies ( /bin/sh -c ), then CMD forms an executable command and parameters that run at container start.

## Source-to-Image Process (S2I)

[S2I Layout](https://role.rhu.redhat.com/rol-rhu/static/static_file_cache/do180-4.0/openshift-dc-and-bc-3.png)

S2I is the primary strategy used for building applications in OpenShift Container Platform. The main reasons for using source builds are:

* User efficiency: Developers do not need to understand Dockerfiles and operating system commands such as yum install . They work using their standard programming language tools.
* Patching: S2I allows for rebuilding all the applications consistently if a base image needs a patch due to a security issue. For example, if a security issue is found in a PHP base image, then updating this image with security patches updates all applications that use this image as a base.
* Speed: With S2I, the assembly process can perform a large number of complex operations without creating a new layer at each step, resulting in faster builds.
* Ecosystem: S2I encourages a shared ecosystem of images where base images and scripts can be customized and reused across multiple types of applications.

To initate a S2I via the CLI, there are a few methods:

* `oc new-app php~http://git.example.com/app --name=myapp` - before the ~ is the name of the image stream and after the ~ is the location of the source repository
* `oc new-app -i php http://git.example.com/app --name=myapp` - same as previous example, but specified with a -i instead of a ~

You can also run a build from a local git repo via `oc new-app .`. When running this way, the local repo must have a remote origin that points to a URL the OpenShift instance can reach. You can also use a remote Git repo and a context subdir: `oc new-app https://github.com/sti-ruby.git --context-dir=2.0/test/puma-test-app`. Lastly, you can use a specific branch of a repo: `oc new-app https://github.com/openshift/ruby-hello-world.git#beta4`.

If an image stream is not specified in the command, `new-app` attempts to determine which language builder to use based on the presence of certain files in the root of the repo:

| Language | Files                        |
| ---      | ---                          |
| Ruby     | Rakefile Gemfile , config.ru |
| Java EE  | pom.xml                      |
| Node.js  | app.json package.json        |
| PHP      | index.php composer.json      |
| Python   | requirements.txt config.py   |
| Perl     | index.pl cpanfile            |

To see a status of builds in the cluster run: `oc get builds`. You can view the build logs by running `oc logs build/app-1`.
