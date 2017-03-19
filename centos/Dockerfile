FROM centos:latest

MAINTAINER "Oleksii Tsvietnov" <me@vorakl.name> 

RUN yum update -y && \
    yum install -y epel-release && \
    yum install -y unzip jq && \
    yum clean all && \
    rm -rf /var/cache/yum/*

# TrivialRC (RC system, initialization/startup control, process manager)
RUN curl -sSLfo /etc/trc http://vorakl.github.io/TrivialRC/trc && \
    ( cd /etc && curl -sSLf http://vorakl.github.io/TrivialRC/trc.sha256 | sha256sum -c ) && \
    chmod +x /etc/trc && \
    /etc/trc --version

# FakeTpl (template engine)
RUN curl -sSLfo /usr/bin/faketpl http://vorakl.github.io/FakeTpl/faketpl && \
    ( cd /usr/bin && curl -sSLf http://vorakl.github.io/FakeTpl/faketpl.sha256 | sha256sum -c )

ENTRYPOINT ["/etc/trc"]
