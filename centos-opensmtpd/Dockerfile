FROM vorakl/centos

ENV RC_VERBOSE true

RUN yum install -y epel-release
RUN yum install -y opensmtpd && \
    yum clean all

CMD ["/usr/sbin/smtpd", "-d"]
