# Alpine base image 

## Tags

* **latest** based on the official [Alpine:latest](https://github.com/gliderlabs/docker-alpine/tree/rootfs/library-3.5/versions/library-3.5)

## Content 

This image has everything is needed for...

* controling a life-cycle of processes inside a container and its behaviour ([TrivialRC](https://github.com/vorakl/TrivialRC))
* getting configuration from the environment and create a final view of configuration using a template engine ([FakeTpl](https://github.com/vorakl/FakeTpl))
* decrypting a downloaded configuration if it has sensitive data and resides on a public resource ([GnuPG](https://www.gnupg.org/))

Such aspects as monitoring, alerting, logging, usually, are done on higher levels (like OS and docker daemon)

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

### Dockerfile

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

### The usage of TrivialRC and FakeTpl in containers

More useful examples you can find here:

* [TrivialRC](https://github.com/vorakl/TrivialRC/tree/master/examples)
* [FakeTpl](https://github.com/vorakl/FakeTpl/tree/master/examples)

