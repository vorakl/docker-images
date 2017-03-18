# The OpenSMTPD docker image based on CentOS

This image provides only default configuration from the original RPM package.
It is based on [vorakl/centos](https://github.com/vorakl/docker-images/tree/master/centos) image which extends the original CentOS base image by a few key tools and it's worth reading if you are not familiar with details.
Keep in mind that by default it uses these directories in a container:

* `/etc/opensmtpd/` , for keeping configuration files like smtpd.conf
* `/var/spool/smtpd/` , for storing messages in a queue temporarily
* `/var/spool/mail/` , as a default place for storing mailboxes

So, if a daemon is going to be used for storing messages (it's not a case for pure forwarders), you need to bind mount `/var/spool/mail/` somewhere on a host to prevent growing of container's space. More over, during a delivery process, a mail relay stores messages in a queue that means on heavy loaded relays you'll need to bind mount `/var/spool/smtpd/` on a host as well. In addition, it doesn't make a lot of sense to run a relay with the default configuration except occasions when you need to send mails from the localhost (`--net host`) or just test the docker image itself. But in most cases, you'll need to provide the real configuration at run-time.

## How to provide configuration?

and there are a few options:

* Bind mount the configuration to `/etc/opensmtpd` from the host
* Download an Zip archive from some http(s) location by setting up OPENSMTPD_CONF_URL environment configuration
* Download a PGP encrypted ZIP archive from some http(s) location by setting up OPENSMTPD_ENCRYPTEDCONF_URL environment configuration. In this case you need to bind mount a private key from the host to `/usr/lib/opensmtpd/private.key`

In all cases, you need to provide an `opensmtpd` (sub-)directory from which will be taken all contents.

## Examples

### A mail relay on the localhost for a host

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

Let's assume that configuration on the host exists at `/srv/opensmtpd/` . Then we can add one more option to the last command

```bash
$ docker run -d --name smtpd --net host -v /srv/opensmtpd:/etc/opensmtpd -v /var/spool/smtpd:/var/spool/smtpd -v /var/spool/mail:/var/spool/mail vorakl/centos-opensmtpd
```

### Download configuration at run-time from a remote resource

[This repository](https://github.com/vorakl/docker-images) has a branch with an example of 'external' configuration. It's called [centos-opensmtpd-conf](https://github.com/vorakl/docker-images/tree/centos-opensmtpd-conf).
GitHub allows to download a content of the branch as a ZIP archive. The only requirement for using external configuration is to keep all needed files and sub-directories in the `opensmtpd` directory.

Let's run the previous example but instead of bind mounted `opensmtpd` from the Host we will provide `opensmtpd` in the external archive:

```bash
$ docker run -d --name smtpd --net host -e OPENSMTPD_CONF_URL="https://github.com/vorakl/docker-images/archive/centos-opensmtpd-conf.zip" -v /var/spool/smtpd:/var/spool/smtpd -v /var/spool/mail:/var/spool/mail vorakl/centos-opensmtpd

2017-03-17 23:51:28 trc [main/1]: The wait policy: wait_any
2017-03-17 23:51:28 trc [main/1]: Launching on the boot: /etc/trc.d/boot.get-conf
2017-03-17 23:51:28 trc [main/1]: The configuration (not encrypted) will be taken from https://github.com/vorakl/docker-images/archive/centos-opensmtpd-conf.zip
Archive:  /tmp/opensmtpd-conf.zip
5d0762c7be974f1c62d9681e72434196e970507e
   creating: /tmp/opensmtpd.KtOL5/docker-images-centos-opensmtpd-conf/
  inflating: /tmp/opensmtpd.KtOL5/docker-images-centos-opensmtpd-conf/README.md
   creating: /tmp/opensmtpd.KtOL5/docker-images-centos-opensmtpd-conf/opensmtpd/
  inflating: /tmp/opensmtpd.KtOL5/docker-images-centos-opensmtpd-conf/opensmtpd/smtpd.conf
'/tmp/opensmtpd.KtOL5/docker-images-centos-opensmtpd-conf/opensmtpd/smtpd.conf' -> '/etc/opensmtpd/smtpd.conf'
2017-03-17 23:51:29 trc [async/31]: Launching on the background: /etc/trc.d/async.opensmtpd
info: OpenSMTPD 6.0.2p1 starting
....

$ docker exec -it smtpd cat /etc/opensmtpd/smtpd.conf
listen on localhost
listen on ::0

accept for any relay

$ docker stop smtpd
$ docker rm smtpd

```
