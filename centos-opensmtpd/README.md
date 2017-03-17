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

In all cases, you need to provide a directory.

## Examples

### A mail realy on the localhost for a host

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

