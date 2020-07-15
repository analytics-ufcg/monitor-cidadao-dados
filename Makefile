.DEFAULT_GOAL : help
help:
	@echo "\nMonitor Cidadão - Serviço de dados"
	@echo "Este arquivo ajuda na obtenção e processamento dos dados usados no Monitor Cidadão\n"
	@echo "COMO USAR:\n\t'make <comando>'\n"
	@echo "COMANDOS:"
	@echo "\thelp \t\t\t\tMostra esta mensagem de ajuda"
	@echo "\tbuild \t\t\t\tRealiza o build das imagens com as \n\t\t\t\t\tdependências necessária para a obtenção e \n\t\t\t\t\tprocessamento dos dados."
	@echo "\tup \t\t\t\tCria e inicia os containers."
	@echo "\tstop \t\t\t\tPara todos os serviços."
	@echo "\tclean-volumes \t\t\tPara e remove todos os volumes."
	@echo "\tenter-fetcher-container \ttAbre cli do container fetcher"
	@echo "\tfetch-data \t\t\tObtem dados"
	@echo "\tenter-transformer-container \tAbre cli do container transformador"
	@echo "\ttransform-data\t\t\tTraduz e transforma os dados colhidos"
	@echo "\tenter-feed-al-container\t\tAbre cli do container feed-al"
	@echo "\tfeed-al-create\t\t\tCria as tabelas do Banco de Dados Analytics"
	@echo "\tfeed-al-import\t\t\tImporta dados para as tabelas do \n\t\t\t\t\tBanco de Dados Analytics"
	@echo "\tfeed-al-clean\t\t\tDropa as tabelas do Banco de Dados \n\t\t\t\t\tAnalytics"
	@echo "\tfeed-al-shell\t\t\tAcessa terminal do Banco de Dados Analytics"
	@echo "\tgera-tipologias \t\tGera as tipologias de contratos"

.PHONY: help
build:
	docker-compose build
.PHONY: build
up:
	docker-compose up -d
.PHONY: up
stop:
	docker-compose stop
.PHONY: stop
clean-volumes:
	docker-compose down --volumes
.PHONY: clean-volumes
enter-fetcher-container:
	docker exec -it fetcher /bin/bash
.PHONY: enter-fetcher-container
fetch-data:
	docker exec -it fetcher sh -c "Rscript scripts/fetch_sagres_data.R"
.PHONY: fetch-data
enter-transformer-container:
	docker exec -it transformador /bin/bash
.PHONY: enter-transformer-container
transform-data:
	docker exec -it transformador sh -c "Rscript scripts/transform_mc_data.R"
.PHONY: transform-data
enter-feed-al-container:
	sudo docker exec -it feed-al sh
.PHONY: enter-feed-al-container
feed-al-create:
	docker exec -it feed-al sh -c "Rscript feed-al/DAO.R -f create"
.PHONY: feed-al-create
feed-al-import:
	docker exec -it feed-al sh -c "Rscript feed-al/DAO.R -f import"
.PHONY: feed-al-import
feed-al-clean:
	docker exec -it feed-al sh -c "Rscript feed-al/DAO.R -f clean"
.PHONY: feed-al-clean
feed-al-shell:
	docker exec -it feed-al sh -c "Rscript feed-al/DAO.R -f shell"
.PHONY: feed-al-shell
gera-tipologias:
	docker exec -it fetcher sh -c "Rscript tipologias/scripts/gera_tipologias.R"
.PHONY: gera-tipologias
