export USER_ID := $(shell id -u)
export GROUP_ID := $(shell id -g)
export CONFIG := docker-compose.yaml

.DEFAULT_GOAL := help

.PHONY: help build up down shell rebuild

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: ## Build the Docker image
	docker compose -f ${CONFIG} build

buildprod: ## Build the production Docker image
	docker build --no-cache -f Dockerfile.prod -t book-lt:0.0.1 .

buildprodq: ## Build the production Docker image
	docker build -f Dockerfile.prod -t book-lt:0.0.1 .

up: ## Start the dev container (daemonized)
	docker compose -f ${CONFIG} up -d

down: ## Stop and remove the dev container
	docker compose -f ${CONFIG} down

shell: ## Shell into the running container as node
	docker compose -f ${CONFIG} exec -u node dev /bin/bash

rebuild: down build up ## Full teardown + rebuild + start
