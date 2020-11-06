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
	@echo ""
	@echo "\tfetch-data-sagres \t\t\tObtem dados do SAGRES-PB"
	@echo "\tfetch-data-tce-rs \t\t\tObtem dados do TCE-RS"
	@echo "\ttransform-data-sagres \t\t\tTraduz e transforma os dados colhidos do SAGRES"
	@echo "\ttransform-data-tce-rs \t\t\tTraduz e transforma os dados colhidos do TCE-RS"
	@echo "\tenter-fetcher-container \ttAbre cli do container fetcher"
	@echo "\tenter-transformer-container \tAbre cli do container transformador"
	@echo "\tenter-feed-al-container\t\tAbre cli do container feed-al"
	@echo ""
	@echo "\tfeed-al-create\t\t\tCria as tabelas do Banco de Dados Analytics"
	@echo "\tfeed-al-import\t\t\tImporta dados para as tabelas do Banco de Dados Analytics"
	@echo "\tfeed-al-import-tce-rs\t\t\tImporta dados do TCE-RS para as tabelas do Banco de Dados Analytics"
	@echo "\tfeed-al-clean\t\t\tDropa as tabelas do Banco de Dados Analytics"
	@echo "\tfeed-al-shell\t\t\tAcessa terminal do Banco de Dados Analytics"
	@echo ""
	@echo "\tfeed-mc-clean\t\t\tDropa as tabelas do banco de dados Monitor Cidadão"
	@echo "\tfeed-mc-create\t\t\tCria as tabelas do banco de dados Monitor Cidadão"
	@echo "\tfeed-mc-import-feature\t\t\tImporta features para o Banco de dados Monitor Cidadão"
	@echo "\tfeed-mc-import-feature-set\t\t\tImporta features set para o Banco de dados Monitor Cidadão"
	@echo "\tfeed-mc-import-experimento\t\t\tImporta experimento para o Banco de dados Monitor Cidadão"
	@echo "\tfeed-mc-shell\t\t\tAcessa terminal do banco de dados Monitor Cidadão"
	@echo ""
	@echo "\tgera-feature vigencia=<encerrados, vigentes e todos> data_range_inicio=<2012-01-01> data_range_fim=<2018-01-01>\t\tGera features"
	@echo "\tgera-feature-set tipo_construcao_features=<recentes>\t\tGera conjunto de features"
	@echo "\tgera-experimento tipo_contrucao_feature_set=<recentes>\t\tGera previsão de risco"

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
fetch-data-tce-rs:
	docker exec -it fetcher sh -c "Rscript scripts/fetch_tce_rs_opendata.R --ano $(ano)"
.PHONY: fetch-data-tce-rs
fetch-data-sagres:
	docker exec -it fetcher sh -c "Rscript scripts/fetch_tramita_pb_2020_data.R"
	docker exec -it fetcher sh -c "Rscript scripts/fetch_ibge.R"
	docker exec -it fetcher sh -c "Rscript scripts/fetch_sagres_data.R"
.PHONY: fetch-data-sagres
enter-transformer-container:
	docker exec -it transformador /bin/bash
.PHONY: enter-transformer-container
transform-data-sagres:
	docker exec -it transformador sh -c "Rscript scripts/transform_mc_data.R"
.PHONY: transform-data-sagres
transform-data-tce-rs:
	docker exec -it transformador sh -c "Rscript scripts/transform_mc_data_tce_rs.R"
.PHONY: transform-data-tce-rs
enter-feed-al-container:
	sudo docker exec -it feed-al sh
.PHONY: enter-feed-al-container
feed-al-create:
	docker exec -it feed-al sh -c "Rscript feed-al/DAO.R -f create"
.PHONY: feed-al-create
feed-al-import:
	docker exec -it feed-al sh -c "Rscript feed-al/DAO.R -f import"
.PHONY: feed-al-import
feed-al-import-tce-rs:
	docker exec -it feed-al sh -c "Rscript feed-al/DAO.R -f import-tce-rs"
.PHONY: feed-al-import-tce-rs
feed-al-clean:
	docker exec -it feed-al sh -c "Rscript feed-al/DAO.R -f clean"
.PHONY: feed-al-clean
feed-al-shell:
	docker exec -it feed-al sh -c "Rscript feed-al/DAO.R -f shell"
.PHONY: feed-al-shell
gera-feature:
	docker exec -it tipologias sh -c "Rscript scripts/gera_feature.R --vigencia $(vigencia) --data_range_inicio $(data_range_inicio) --data_range_fim $(data_range_fim)"
.PHONY: gera-feature
gera-feature-set:
	docker exec -it tipologias sh -c "Rscript scripts/gera_feature_set.R --tipo_construcao_features $(tipo_construcao_features)"
.PHONY: gera-feature-set
gera-experimento:
	docker exec -it tipologias sh -c "Rscript scripts/gera_experimento.R --tipo_contrucao_feature_set $(tipo_contrucao_feature_set)"
.PHONY: gera-experimento
enter-feed-mc-container:
	sudo docker exec -it feed-mc sh
.PHONY: enter-feed-mc-container
feed-mc-create:
	docker exec -it feed-mc sh -c "Rscript feed-mc/DAO.R -f create"
.PHONY: feed-mc-create
feed-mc-import-feature:
	docker exec -it feed-mc sh -c "Rscript feed-mc/DAO.R -f import_feature"
.PHONY: feed-mc-import-feature
feed-mc-import-feature-set:
	docker exec -it feed-mc sh -c "Rscript feed-mc/DAO.R -f import_feature_set"
.PHONY: feed-mc-import-feature-set
feed-mc-import-experimento:
	docker exec -it feed-mc sh -c "Rscript feed-mc/DAO.R -f import_experimento"
.PHONY: feed-mc-import-experimento
feed-mc-clean:
	docker exec -it feed-mc sh -c "Rscript feed-mc/DAO.R -f clean"
.PHONY: feed-mc-clean
feed-mc-shell:
	docker exec -it feed-mc sh -c "Rscript feed-mc/DAO.R -f shell"
.PHONY: feed-mc-shell
