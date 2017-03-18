[![Build Status](https://api.travis-ci.org/vorakl/docker-images.png)](https://travis-ci.org/vorakl/docker-images)

# Docker images

A collection of docker images.

For all images, *once a day* and on *each commit* to this source repo, automatically are being run:

* [tests](https://travis-ci.org/vorakl/docker-images) (Travis CI)
* [builds](https://hub.docker.com/u/vorakl/) (Docker Hub)

## Available images

You can download any of these images by specifying a name[:tag].
For example `docker pull vorakl/centos:latest` or `docker pull vorakl/alpine`

* Base images
    * [vorakl/centos](https://github.com/vorakl/docker-images/tree/master/centos)
    * [vorakl/alpine](https://github.com/vorakl/docker-images/tree/master/alpine)
* Service images
    * [vorakl/centos-opensmtpd](https://github.com/vorakl/docker-images/tree/master/centos-opensmtpd)
