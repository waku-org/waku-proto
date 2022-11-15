.DEFAULT_GOAL := all

all: lint breaking

format:
	@buf format -w

lint:
	@echo "Running buf lint"
	@buf lint

breaking:
	@echo "Running buf breaking changes checks"
	@buf breaking --against="https://github.com/vacp2p/waku.git#branch=main"

build:
	@echo "Running buf compilation"
	@buf build
