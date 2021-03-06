# The OpenSMTPD docker image based on CentOS

* [Tags](#tags)
* [Content](#content)
* [Directories structure](#directories-structure)
* [How to supply configuration?](#how-to-provide-configuration)
* [Examples](#examples)
    * [A mail relay for a Host on the localhost interface](#a-mail-relay-for-a-host-on-the-localhost-interface)
    * [Mount configuration from a host](#mount-configuration-from-a-host)
    * [Download configuration at run-time from a remote resource](#download-configuration-at-run-time-from-a-remote-resource)

## Tags

* **latest** is based on Vorakl's CentOS base image [vorakl/centos:latest](https://hub.docker.com/r/vorakl/centos/)

## Content

The content (a base layer, packages, etc) of this image is automatically updated *once a day* and on *each commit* to the source repository. All key components are automatically tested with the same periodicity as well.
The [vorakl/centos-opensmtpd](https://hub.docker.com/r/vorakl/centos-opensmtpd/) image is a part of [the collection of docker images](https://github.com/vorakl/docker-images) where can be found links to tests and other images

This image provides only default configuration from the original RPM package.
It is based on [vorakl/centos](https://hub.docker.com/r/vorakl/centos/) image which extends the official [CentOS base](https://hub.docker.com/_/centos/) image by a few key tools and it's worth reading if you are not familiar with details.

## Directories structure

Keep in mind that by default it uses these directories in a container:

* `/etc/opensmtpd/` , for keeping configuration files like smtpd.conf
* `/var/spool/smtpd/` , for storing messages in a queue temporarily
* `/var/spool/mail/` , as a default place for storing mailboxes

So, if a daemon is going to be used for storing messages (it's not a case for pure forwarders), you need to bind mount `/var/spool/mail/` somewhere on a host to prevent growing of container's space. More over, during a delivery process, a mail relay stores messages in a queue that means on heavy loaded relays you'll need to bind mount `/var/spool/smtpd/` on a host as well. In addition, it doesn't make a lot of sense to run a relay with the default configuration except occasions when you need to send mails from the localhost (`--net host`) or just test the docker image itself. But in most cases, you'll need to provide the real configuration at run-time.

## How to supply configuration?

and there are a few options:

* Bind mount the configuration to `/etc/opensmtpd` from the host
* Download an Zip archive from some http(s) location by setting up OPENSMTPD_CONF_URL environment configuration
* Download a PGP encrypted ZIP archive from some http(s) location by setting up OPENSMTPD_ENCRYPTEDCONF_URL environment configuration. In this case you need to bind mount a private key from the host to `/usr/lib/opensmtpd/private.key`

In all cases, you need to provide an `opensmtpd` (sub-)directory from which will be taken all contents.

## Examples

### A mail relay for a Host on the localhost interface

This is the simplest use case, doesn't require any configuration files

```bash
$ docker run -d --name smtpd --net host vorakl/centos-opensmtpd

$ docker exec smtpd smtpctl show status
MDA running
MTA running
SMTP running
```
A little bit better way is 

```bash
$ sudo sh -c 'mkdir /var/spool/smtpd; chmod 711 /var/spool/smtpd'

$ docker run -d --name smtpd --net host -v /var/spool/smtpd:/var/spool/smtpd -v /var/spool/mail:/var/spool/mail vorakl/centos-opensmtpd

$ docker exec smtpd smtpctl show status
MDA running
MTA running
SMTP running
```
Of course, to have proper UIDs/GIDs in /var/spool/mail/ it needs to know about users on the host and an appropriate configuration but this goes beyond default configuration. Defaults would be useful, for example, only for sending messages from the Host to the upstream mail relay in a local network, etc.

To remove the container run

```bash
$ docker stop smtpd
$ docker rm smtpd
```

### Mount configuration from a host

Let's assume that configuration on the host exists at `/srv/opensmtpd/` . Then we can add one more option to the previous example:

```bash
$ docker run -d --name smtpd --net host -v /srv/opensmtpd:/etc/opensmtpd -v /var/spool/smtpd:/var/spool/smtpd -v /var/spool/mail:/var/spool/mail vorakl/centos-opensmtpd
```

### Download configuration at run-time from a remote resource

This approach is more suitable for running a service at scale on a cluster with a big number of nodes under control of some orchestration system. In this case, all nodes are used only to run containers and do not have any specific configuration that, by the way, can be changed too often to distribute it in time among the nodes. A better solution is to run a container on a random node and download an actual configuration at run-time from a central configuration storage (like a Git repository, for example).

[This repository](https://github.com/vorakl/docker-images) has a branch with an example of 'external' configuration. It's called [centos-opensmtpd-conf](https://github.com/vorakl/docker-images/tree/centos-opensmtpd-conf). GitHub allows to download a content of a branch as a ZIP archive. The only requirement in this particular solution for using external configuration is to keep all needed files and sub-directories in the `opensmtpd` directory.

Let's run the previous example but instead of bind mounted `opensmtpd` directory from the Host we will provide it in the external archive:

```bash
$ docker run -d --name smtpd --net host -e OPENSMTPD_CONF_URL="https://github.com/vorakl/docker-images/archive/centos-opensmtpd-conf.zip" -v /var/spool/smtpd:/var/spool/smtpd -v /var/spool/mail:/var/spool/mail vorakl/centos-opensmtpd

$ docker logs smtpd |& head
2017-03-18 19:58:40 trc [main/1]: The wait policy: wait_any
2017-03-18 19:58:40 trc [main/1]: Launching on the boot: /etc/trc.d/boot.get-conf
2017-03-18 19:58:40 trc [main/1]: The configuration (not encrypted) will be taken from https://github.com/vorakl/docker-images/archive/centos-opensmtpd-conf.zip
2017-03-18 19:58:42 trc [async/32]: Launching on the background: /etc/trc.d/async.opensmtpd
info: OpenSMTPD 6.0.2p1 starting
setup_peer: lookup -> control[40] fd=6
setup_peer: lookup -> pony express[42] fd=7
setup_peer: lookup -> queue[43] fd=8
setup_peer: pony express -> control[40] fd=7
setup_peer: pony express -> klondike[39] fd=8

$ docker exec -it smtpd cat /etc/opensmtpd/smtpd.conf
listen on 127.0.0.1
listen on ::0
accept for any relay
```
To remove the container run

```bash
$ docker stop smtpd
$ docker rm smtpd
```
