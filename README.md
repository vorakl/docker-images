[![Build Status](https://api.travis-ci.org/vorakl/docker-images.png)](https://travis-ci.org/vorakl/docker-images)

# Docker images

A collection of useful docker images.

For all images, *once a day* and on *each commit* to this source repository, automatically are being run:

* [tests](https://travis-ci.org/vorakl/docker-images) (Travis CI)
* [builds](https://hub.docker.com/u/vorakl/) (Docker Hub)

For testing services in containers is being used [this technic](https://github.com/vorakl/TrivialRC/tree/master/examples/reliable-tests-for-docker-images).

## Available images

Any of these images can be downloaded by specifying a name[:tag]. <br />
For example `docker pull vorakl/centos:latest` or `docker pull vorakl/alpine`

* Base images
    * [vorakl/centos](https://github.com/vorakl/docker-images/tree/master/centos)
    * [vorakl/alpine](https://github.com/vorakl/docker-images/tree/master/alpine)
* Service images
    * [vorakl/centos-opensmtpd](https://github.com/vorakl/docker-images/tree/master/centos-opensmtpd)
