# Tekton Learnings

Dockerfiles must have a path (shortname not possible) if using Buildah image (1.17 did not have this issue, but 1.23.1 does). 
Bad: `golang:latest` vs Good: `docker.io/golang:latest`
