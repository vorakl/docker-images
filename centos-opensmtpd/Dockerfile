FROM vorakl/centos

MAINTAINER "Oleksii Tsvietnov" <me@vorakl.name>

ENV RC_VERBOSE true

RUN yum install -y opensmtpd && \
    yum clean all

COPY trc.d/ /etc/trc.d/

EXPOSE 25 465
