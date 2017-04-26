
A collection of useful docker images
####################################

:slug: info
:summary: A collection of useful docker images

|build-status|

A collection of useful docker images.
For all images, **once a day** and on **each commit** to this source repository, automatically are being run:

* tests_
* builds_

For testing services in containers is being used `this technic`_.

Available images
================

Any of these images can be downloaded by specifying a **name[:tag]**.
For example ``docker pull vorakl/centos:latest`` or ``docker pull vorakl/alpine``.

* Base images
    * `vorakl/centos`_
    * `vorakl/alpine`_

* Service images
    * `vorakl/alpine-pelican`_
    * `vorakl/centos-opensmtpd`_

.. Links

.. _tests: https://travis-ci.org/vorakl/docker-images
.. _builds: https://hub.docker.com/u/vorakl/
.. _`this technic`: https://github.com/vorakl/TrivialRC/tree/master/examples/reliable-tests-for-docker-images
.. _`vorakl/centos`: https://github.com/vorakl/docker-images/tree/master/centos
.. _`vorakl/alpine`: https://github.com/vorakl/docker-images/tree/master/alpine
.. _`vorakl/alpine-pelican`: https://github.com/vorakl/docker-images/tree/master/alpine-pelican
.. _`vorakl/centos-opensmtpd`: https://github.com/vorakl/docker-images/tree/master/centos-opensmtpd
.. |build-status| image:: https://travis-ci.org/vorakl/docker-images.svg?branch=master
   :target: https://travis-ci.org/vorakl/docker-images
   :alt: Travis CI: continuous integration status
