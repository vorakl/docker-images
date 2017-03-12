# CentOS base image

## Tags

* **latest** based on the official [CentOS:latest](https://github.com/CentOS/sig-cloud-instance-images/tree/CentOS-7/docker)

## Content

This image has everything is needed for...

* controling a life-cycle of processes inside a container and its behaviour ([TrivialRC](https://github.com/vorakl/TrivialRC))
* getting configuration from the environment and create a final view of configuration using a template engine ([FakeTpl](https://github.com/vorakl/FakeTpl))
* decrypting a downloaded configuration if it has sensitive data and resides on a public resource ([GnuPG](https://www.gnupg.org/))

Such aspects as monitoring, alerting, logging, usually, are done on higher levels (like OS and docker daemon)

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

