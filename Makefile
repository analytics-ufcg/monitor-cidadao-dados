.DEFAULT_GOAL : help
help:
	@echo "\nMonitor Cidadão - Serviço de dados"
.PHONY: help
build:
	docker-compose build
.PHONY: build
run:
	docker-compose up -d
.PHONY: run
stop:
	docker-compose stop
.PHONY: stop
clean-volumes:
	docker-compose down --volumes
.PHONY: clean-volumes
enter-container:
	docker exec -it r-container-fetcher /bin/bash
.PHONY: enter-container