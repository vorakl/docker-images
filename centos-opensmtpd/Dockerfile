FROM vorakl/centos

MAINTAINER "Oleksii Tsvietnov" <me@vorakl.name>

ENV RC_VERBOSE true

RUN yum install -y epel-release
RUN yum install -y opensmtpd && \
    yum clean all

CMD ["-D", "/usr/sbin/smtpd -d"]
