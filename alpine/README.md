# Alpine base image 

* [Tags](#tags)
* [Content](#content)
* [Examples](#examples)
    * [One-Liners](#one-liners)
    * [Dockerfiles](#dockerfiles)
    * [TrivialRC and FakeTpl in containers](#trivialrc-and-faketpl-in-containers)

## Tags

* **latest** based on the official [alpine:latest](https://hub.docker.com/_/alpine/)

## Content 

The content (a base layer, packages, etc) of this image is automatically updated *once a day* and on *each commit* to the source repository. That means it's always *up to date*, including packages which were updated since the release date of the official base image. All key components are automatically tested with the same periodicity. The [vorakl/alpine](https://hub.docker.com/r/vorakl/alpine/) image is a part of [the collection of docker images](https://github.com/vorakl/docker-images) where can be found links to tests and other images.

In addition, it has everything is needed for...

* controling a life-cycle of processes ([TrivialRC](https://github.com/vorakl/TrivialRC))
* getting configuration from the environment and creating a final view of configuration using a template engine ([FakeTpl](https://github.com/vorakl/FakeTpl))
* decrypting and extracting downloaded configuration if it has sensitive data and resides on a public resource ([GnuPG](https://www.gnupg.org/), unzip)

Such aspects as monitoring, alerting, logging, usually, are done on higher levels (like OS and docker daemon) and is not represented in the image.

## Examples

### One-Liners

```bash
$ docker run --rm -it vorakl/alpine bash

bash-4.3#

```

```bash
$ docker run --rm -it -e RC_WAIT_POLICY=wait_all vorakl/alpine -B 'name=Anonymous' -F 'echo "Hello, ${name}"' -F 'uptime' -F 'echo "Good Bye, ${name}"'

Hello, Anonymous
 21:59:47 up 9 days, 11:05,  0 users,  load average: 0.06, 0.25, 0.32
Good Bye, Anonymous

```

```bash
$ docker run --rm -it -e RC_WAIT_POLICY=wait_err vorakl/alpine -F 'echo "Hello, $(id -un)"' -F 'false' -F 'echo "You will not see this"'

Hello, root

```

```bash
$ docker run --rm -e RC_WAIT_POLICY=wait_all vorakl/alpine -B 'source faketpl' -F 'source /etc/os-release && faketp<<< "-=[\${PRETTY_NAME}]=-"' -F 'gpg --version | grep ^gpg' -F 'curl --version | grep ^curl' -F 'faketpl <<< "-=[\$(uname -r)]=-"'

-=[Alpine Linux v3.5]=-
gpg (GnuPG) 1.4.21
curl 7.52.1 (x86_64-alpine-linux-musl) libcurl/7.52.1 LibreSSL/2.4.4 zlib/1.2.8 libssh2/1.7.0
-=[4.9.11-200.fc25.x86_64+debug]=-

```

```bash
$ docker run --rm -e RC_WAIT_POLICY=wait_all vorakl/alpine -D 'sleep 2; echo "Yoda"' -D 'sleep 1; echo "is talking"'  -D 'echo "to you"'

to you
is talking
Yoda

```

### Dockerfiles

* A basic usage in Dockerfile

```bash
FROM vorakl/alpine:latest

ENV RC_VERBOSE=true
#ENV RC_VERBOSE_EXTRA=true
#ENV RC_DEBUG=true

CMD ["uname", "-a"]

```
Then, build and run it:

```bash
$ docker build -t base-alpine-test1 .

$ docker run --rm base-alpine-test1

2017-03-12 22:34:12 trc [main/1]: The wait policy: wait_any
2017-03-12 22:34:12 trc [sync/19]: Launching on the foreground: uname -a
Linux d1d95e2cb8e2 4.9.11-200.fc25.x86_64+debug #1 SMP Mon Feb 20 17:56:54 UTC 2017 x86_64 Linux
2017-03-12 22:34:12 trc [sync/19]: Exiting on the foreground (exitcode=0): uname -a
2017-03-12 22:34:12 trc [main/1]: Trying to terminate sub-processes...
2017-03-12 22:34:12 trc [main/1]: Exited (exitcode=0)

```

* Another example:

```bash
FROM vorakl/alpine:latest

ENV RC_WAIT_POLICY=wait_all

CMD ["-D", "sleep 2; echo World", "-D", "echo Hello"]

```

Then, build and run it:

```bash
$ docker build -t base-alpine-test2 .

$ docker run --rm base-alpine-test2

Hello
World

```

### TrivialRC and FakeTpl in containers

More useful examples you can find here:

* [TrivialRC examples](https://github.com/vorakl/TrivialRC/tree/master/examples)
* [FakeTpl examples](https://github.com/vorakl/FakeTpl/tree/master/examples)

