MAKEFLAGS += --warn-undefined-variables --no-print-directory
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
.DELETE_ON_ERROR:
.SUFFIXES:

REPO = sphinx-server
DOCKERFILE = ./Dockerfile
GIT_COMMIT := $(shell git rev-parse HEAD)
GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
GIT_SHORT_COMMIT := $(shell git rev-parse --short HEAD)

# Generate Version
MAJOR_MINOR_VER = 1.0

.PHONY: help
help:
	$(info Available make targets:)
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

.PHONY: build
build: ## Build docker image
	$(info *** Building docker image)
	@docker build \
		--tag xihelm/$(REPO):latest \
		--file $(DOCKERFILE) \
		.
.PHONY: push
push:  ## Push docker image
	$(info *** Pushing docker image: xihelm/$(REPO):latest)
	@docker push xihelm/$(REPO):latest
