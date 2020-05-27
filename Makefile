.DEFAULT_GOAL : help
help:
	@echo "\nMonitor Cidadão - Serviço de dados"
.PHONY: help
build:
	docker-compose build
.PHONY: build
run:
	docker-compose up -d
	docker exec -it r-container-fetcher /bin/bash -c "sudo apt -y install openssh-server"
	sudo docker exec -it r-container-fetcher /bin/bash -c "mkdir /root/.ssh"
	sudo docker cp config r-container-fetcher:/root/.ssh/
	sudo docker cp id_rsa.pub r-container-fetcher:/root/.ssh/
	sudo docker cp id_rsa r-container-fetcher:/root/.ssh/
	sudo docker cp known_hosts r-container-fetcher:/root/.ssh/
	docker exec -it r-container-fetcher /bin/bash -c "chown root ~/.ssh/config"
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