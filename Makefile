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
enter-fetcher-container:
	docker exec -it fetcher /bin/bash
.PHONY: enter-fetcher-container
enter-transformer-container:
	docker exec -it transformador /bin/bash
.PHONY: enter-transformer-container
transform-data:
	docker exec -it transformador sh -c "Rscript scripts/transform_mc_data.R"
.PHONY: transform-data
