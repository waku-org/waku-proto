.DEFAULT_GOAL := build

all: lint build

format:
	@buf format -w

lint:
	@buf lint

build:
	@buf build