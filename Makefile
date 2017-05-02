# (c) 2017 Oleksii Tsvietnov, me@vorakl.name, All rights reserved
#
## Variables:
ECHO_BIN ?= echo
DOCKER_BIN ?= docker

# -------------------------------------------------------------------------
## Set a default target
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
	@${ECHO_BIN} "  trigger  Trigger a build of docker images on Docker Hub"
	@${ECHO_BIN} ""

## Trigger a build on Docker Hub

trigger: trigger-base

trigger-base: trigger-alpine trigger-centos

trigger-alpine:
	@${ECHO_BIN} -n ">>> Triggering build and push of vorakl/alpine ... "
	@curl -H "Content-Type: application/json" --data '{"build": true}' -X POST https://registry.hub.docker.com/u/vorakl/alpine/trigger/24d5ca99-fe04-4274-b8f0-18fd86e58b7f/
	@${ECHO_BIN} ""

trigger-centos:
	@${ECHO_BIN} -n ">>> Triggering build and push of vorakl/centos ... "
	@curl -H "Content-Type: application/json" --data '{"build": true}' -X POST https://registry.hub.docker.com/u/vorakl/centos/trigger/47dad8a3-d5d1-4664-b437-92d94c2a8767/
	@${ECHO_BIN} ""

## Build docker images

build:  build-base build-service

build-base: build-alpine build-centos

build-service: build-centos-opensmtpd build-alpine-pelican

build-alpine:
	@${ECHO_BIN} ">>> Building vorakl/alpine ..."
	@${DOCKER_BIN} build --no-cache -t vorakl/alpine alpine

build-centos:
	@${ECHO_BIN} ">>> Building vorakl/centos ..."
	@${DOCKER_BIN} build --no-cache -t vorakl/centos centos

build-centos-opensmtpd:
	@${ECHO_BIN} ">>> Building vorakl/centos-opensmtpd ..."
	@${DOCKER_BIN} build --no-cache -t vorakl/centos-opensmtpd centos-opensmtpd

build-alpine-pelican:
	@${ECHO_BIN} ">>> Building vorakl/alpine-pelican ..."
	@${DOCKER_BIN} build --no-cache -t vorakl/alpine-pelican alpine-pelican

## Test docker images

test:	test-alpine test-centos test-centos-opensmtpd test-alpine-pelican

test-alpine:
	@${ECHO_BIN} -e "\n>>> Testing vorakl/alpine ..."
	@${DOCKER_BIN} run \
	    --rm \
	    --env RC_WAIT_POLICY=wait_err \
	    vorakl/alpine \
	    	-B 'source faketpl' \
		-F 'source /etc/os-release && faketpl <<< "-=[\$${PRETTY_NAME}]=-"' \
		-F 'bash -c "echo bash \$${BASH_VERSION}"' \
		-F 'gpg --version | grep ^gpg' \
		-F 'curl --version | grep ^curl' \
		-F 'jq --version' \
		-F 'faketpl <<< "-=[\$$(uname -r)]=-"'

test-centos:
	@${ECHO_BIN} -e "\n>>> Testing vorakl/centos ..."
	@${DOCKER_BIN} run \
	    --rm \
	    --env RC_WAIT_POLICY=wait_err \
	    vorakl/centos \
	    	-B 'source faketpl' \
		-F 'faketpl <<< "-=[\$$(cat /etc/centos-release)]=-"' \
		-F 'bash -c "echo bash \$${BASH_VERSION}"' \
		-F 'gpg --version | grep ^gpg' \
		-F 'curl --version | grep ^curl' \
		-F 'jq --version' \
		-F 'faketpl <<< "-=[\$$(uname -r)]=-"'

test-centos-opensmtpd:
	@${ECHO_BIN} -e "\n>>> Testing vorakl/centos-opensmtpd ..."
	@${DOCKER_BIN} run \
	    --rm \
	    --env RC_VERBOSE=false \
	    --env RC_WAIT_POLICY=wait_any \
	    vorakl/centos-opensmtpd \
		-H 'if [[ $${_exit_status} -eq 138 ]]; then exit 0; else exit $${_exit_status}; fi' \
		-D 'sleep 3; smtpctl show status && kill -10 $${MAINPID}'

test-alpine-pelican:
	@${ECHO_BIN} -e "\n>>> Testing vorakl/alpine-pelican ..."
	@${DOCKER_BIN} run \
	    --rm \
	    --user $$(id -u):$$(id -g) \
	    -v $$(pwd)/tests/alpine-pelican:/site \
	    vorakl/alpine-pelican \
	    	-H 'if [[ $${_exit_status} -eq 0 ]]; then \
			if [[ ! -f /site/output/hello.html ]]; then \
				echo "A test html file has not been generated" >&2; \
				_exit_status=1; \
			fi; \
		    fi; \
		    rm -rf /site/output/*; \
		    exit $${_exit_status}' \
		-F 'pelican /site/input -o /site/output -s /site/pelicanconf.py'

