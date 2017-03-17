# The example of configuration for vorakl/centos-opensmtpd docker image

This configuration can be used by setting up OPENSMTPD_CONF_URL environment variable to the direct link to ZIP archive of the `centos-opensmtpd-conf` branch. For example,

```bash
$ docker run --rm -it -e OPENSMTPD_CONF_URL="https://github.com/vorakl/docker-images/archive/centos-opensmtpd-conf.zip" --net host vorakl/centos-opensmtpd
```
