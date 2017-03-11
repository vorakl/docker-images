FROM centos:latest

RUN curl -sSLfo /etc/trc http://vorakl.github.io/TrivialRC/trc && \
    ( cd /etc && curl -sSLf http://vorakl.github.io/TrivialRC/trc.sha256 | sha256sum -c ) && \
    chmod +x /etc/trc && \
    /etc/trc --version

RUN curl -sSLfo /usr/bin/faketpl http://vorakl.github.io/FakeTpl/faketpl && \
    ( cd /usr/bin && curl -sSLf http://vorakl.github.io/FakeTpl/faketpl.sha256 | sha256sum -c )

ENTRYPOINT ["/etc/trc"]
