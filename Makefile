ifneq (, $(shell which tput))
	GREEN  := $(shell tput -Txterm setaf 2)
	YELLOW := $(shell tput -Txterm setaf 3)
	WHITE  := $(shell tput -Txterm setaf 7)
	CYAN   := $(shell tput -Txterm setaf 6)
	RESET  := $(shell tput -Txterm sgr0)
endif

# Git
GIT_VERSION ?= $(shell git describe --abbrev=6 --always --tags)
GIT_REMOTE_URL ?= $(shell git remote get-url origin | sed 's|git@github.com:|https://github.com/|')

# Buf.build
BUF=buf

ifeq (, $(shell which $(BUF)))
$(error "No buf command in $$PATH, see: https://buf.build/docs/installation/#install-the-buf-cli")
endif


.DEFAULT_GOAL := all

all: lint breaking

## Buf
format:
	$(BUF) format -w

lint:  ## Run buf.build lint
	$(BUF) lint

breaking:  ## Run buf.build breaking changes checks
	$(BUF) breaking --against="${GIT_REMOTE_URL}#branch=main"

build:  ## Run buf.build compilation
	$(BUF) build

## Help:
help:	## Show this help
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "    ${YELLOW}%-20s${GREEN}%s${RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  ${CYAN}%s${RESET}\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)
