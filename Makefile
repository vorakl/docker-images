# (c) Oleksii Tsvietnov, me@vorakl.name
#
# Variables:
ECHO_BIN ?= echo
DOCKER_BIN ?= docker

# -------------------------------------------------------------------------
# Set a default target
.MAIN: usage

DIR = $(shell ${PWD_BIN} -P)

usage:
	@${ECHO_BIN} "Usage: make [target] ..."
	@${ECHO_BIN} ""
	@${ECHO_BIN} "Examples: make build"
	@${ECHO_BIN} "          make test"
	@${ECHO_BIN} ""
	@${ECHO_BIN} "Description:"
	@${ECHO_BIN} "  build    Build all docker images"
	@${ECHO_BIN} "  test     Run tests for docker images"
	@${ECHO_BIN} ""

build:  build-base build-service

build-base: build-alpine build-centos

build-service: build-centos-opensmtpd

build-alpine:
	@${ECHO_BIN} ">>> Building vorakl/alpine ..."
	@${DOCKER_BIN} build --no-cache -t vorakl/alpine alpine

build-centos:
	@${ECHO_BIN} ">>> Building vorakl/centos ..."
	@${DOCKER_BIN} build --no-cache -t vorakl/centos centos

build-centos-opensmtpd:
	@${ECHO_BIN} ">>> Building vorakl/centos-opensmtpd ..."
	@${DOCKER_BIN} build --no-cache -t vorakl/centos-opensmtpd centos-opensmtpd

test:	test-alpine test-centos test-centos-opensmtpd

test-alpine:
	@${ECHO_BIN} ">>> Testing vorakl/alpine ..."
	@${DOCKER_BIN} run --rm -e RC_WAIT_POLICY=wait_all vorakl/alpine -B 'source faketpl' -F 'source /etc/os-release && faketpl <<< "-=[\$${PRETTY_NAME}]=-"' -F 'gpg --version | grep ^gpg' -F 'curl --version | grep ^curl' -F 'faketpl <<< "-=[\$$(uname -r)]=-"'

test-centos:
	@${ECHO_BIN} ">>> Testing vorakl/centos ..."
	@${DOCKER_BIN} run --rm -e RC_WAIT_POLICY=wait_all vorakl/centos -B 'source faketpl' -F 'faketpl <<< "-=[\$$(cat /etc/centos-release)]=-"' -F 'gpg --version | grep ^gpg' -F 'curl --version | grep ^curl' -F 'faketpl <<< "-=[\$$(uname -r)]=-"'

test-centos-opensmtpd:
	@${ECHO_BIN} ">>> Testing vorakl/centos-opensmtpd ..."
	@${DOCKER_BIN} run --rm vorakl/centos-opensmtpd -H 'if [[ $${_exit_status} -eq 138 ]]; then exit 0; else exit $${_exit_status}; fi' -D 'sleep 3; smtpctl show status && kill -10 $${MAINPID}'

