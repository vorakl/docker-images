FROM alpine:latest

RUN apk add --no-cache bash procps

RUN wget -qP /etc/ http://vorakl.github.io/TrivialRC/trc && \
    ( cd /etc && wget -qO - http://vorakl.github.io/TrivialRC/trc.sha256 | sha256sum -c ) && \
    chmod +x /etc/trc && \
    /etc/trc --version

RUN wget -qP /usr/bin/ http://vorakl.github.io/FakeTpl/faketpl && \
    ( cd /usr/bin && wget -qO - http://vorakl.github.io/FakeTpl/faketpl.sha256 | sha256sum -c )

ENTRYPOINT ["/etc/trc"]
