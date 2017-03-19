# CentOS base image

* [Tags](#tags)
* [Content](#content)
* [Examples](#examples)
    * [One-Liners](#one-liners)
    * [Dockerfiles](#dockerfiles)
    * [TrivialRC and FakeTpl in containers](#trivialrc-and-faketpl-in-containers)

## Tags

* **latest** is based on the official [centos:latest](https://hub.docker.com/_/centos/)

## Content

The content (a base layer, packages, etc) of this image is automatically updated *once a day* and on *each commit* to the source repository. That means it's always *up to date*, including packages which were updated since the release date of the official base image. All key components are automatically tested with the same periodicity. The [vorakl/centos](https://hub.docker.com/r/vorakl/centos/) image is a part of [the collection of docker images](https://github.com/vorakl/docker-images) where can be found links to tests and other images.

In addition, it has everything is needed for...

* installing extra packages ([EPEL](https://fedoraproject.org/wiki/EPEL))
* controlling a life-cycle of processes ([TrivialRC](https://github.com/vorakl/TrivialRC))
* getting configuration from the environment and creating a final state of configuration using a template engine ([FakeTpl](https://github.com/vorakl/FakeTpl))
* decrypting and extracting downloaded configuration if it has sensitive data and resides on a public resource ([GnuPG](https://www.gnupg.org/), unzip)

Such aspects as monitoring, alerting, logging, usually, are done on higher levels (like OS and docker daemon) and are not represented in the image.

## Examples

### One-Liners

```bash
$ docker run --rm -it vorakl/centos bash

[root@9717ed0fb0b6 /]#

```

```bash
$ docker run --rm -it -e RC_WAIT_POLICY=wait_all vorakl/centos -B 'name=Anonymous' -F 'echo "Hello, ${name}"' -F 'uptime' -F 'echo "Good Bye, ${name}"'

Hello, Anonymous
 22:19:19 up 9 days, 11:25,  0 users,  load average: 0.41, 0.33, 0.33
Good Bye, Anonymous

```

```bash
$ docker run --rm -it -e RC_WAIT_POLICY=wait_err vorakl/centos -F 'echo "Hello, $(id -un)"' -F 'false' -F 'echo "You will not see this"'

Hello, root

```

```bash
$ docker run --rm -e RC_WAIT_POLICY=wait_all vorakl/centos -B 'source faketpl' -F 'faketpl <<< "-=[\$(cat /etc/centos-release)]=-"' -F 'gpg --version | grep ^gpg' -F 'curl --version | grep ^curl' -F 'faketpl <<< "-=[\$(uname -r)]=-"'

-=[CentOS Linux release 7.3.1611 (Core) ]=-
gpg (GnuPG) 2.0.22
curl 7.29.0 (x86_64-redhat-linux-gnu) libcurl/7.29.0 NSS/3.21 Basic ECC zlib/1.2.7 libidn/1.28 libssh2/1.4.3
-=[4.9.11-200.fc25.x86_64+debug]=-

```

```bash
$ docker run --rm -e RC_WAIT_POLICY=wait_all vorakl/centos -D 'sleep 2; echo "Yoda"' -D 'sleep 1; echo "is talking"'  -D 'echo "to you"'

to you
is talking
Yoda

```

### Dockerfiles

* Basic usage in a Dockerfile

```bash
FROM vorakl/centos:latest

ENV RC_VERBOSE=true
#ENV RC_VERBOSE_EXTRA=true
#ENV RC_DEBUG=true

CMD ["uname", "-a"]

```

Then, build and run it:

```bash
$ docker build -t base-centos-test1 .

$ docker run --rm base-centos-test1

2017-03-13 15:53:09 trc [main/1]: The wait policy: wait_any
2017-03-13 15:53:09 trc [sync/18]: Launching on the foreground: uname -a
Linux 47a37108ff23 4.9.11-200.fc25.x86_64+debug #1 SMP Mon Feb 20 17:56:54 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
2017-03-13 15:53:09 trc [sync/18]: Exiting on the foreground (exitcode=0): uname -a
2017-03-13 15:53:09 trc [main/1]: Trying to terminate sub-processes...
2017-03-13 15:53:09 trc [main/1]: Exited (exitcode=0)

```

* Another example:

```bash
FROM vorakl/centos:latest

ENV RC_WAIT_POLICY=wait_all

CMD ["-D", "sleep 2; echo World", "-D", "echo Hello"]

```

Then, build and run it:

```bash
$ docker build -t base-centos-test2 .

$ docker run --rm base-centos-test2

Hello
World

```

### TrivialRC and FakeTpl in containers

More useful examples you can find here:

* [TrivialRC examples](https://github.com/vorakl/TrivialRC/tree/master/examples)
* [FakeTpl examples](https://github.com/vorakl/FakeTpl/tree/master/examples)

