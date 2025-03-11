.PHONY: up down run-dbt-docs add-dbt-tbls dbt-compile

DOCKER_COMPOSE_FILE=docker-compose.yml

up: ## Start all or c=<name> containers in foreground
	docker compose --project-name dbttest -f $(DOCKER_COMPOSE_FILE) up $(c) -d

down: ## Start all or c=<name> containers in foreground
	docker compose --project-name dbttest -f $(DOCKER_COMPOSE_FILE) down

postgres-ip:
	docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dbtpostgres

postgres-shell:
	docker exec -it dbtpostgres psql -U username dbt_test

start: ## Start all or c=<name> containers in background
	docker compose --project-name dbttest -f $(DOCKER_COMPOSE_FILE) up -d $(c)
	docker exec -it dbtpostgres psql -U username -d dbt_test -a -f var/scripts/build.sql
	docker exec -it dbtpostgres psql -U username -d dbt_test -a -f var/scripts/add_data.sql
	docker exec -it dbtpostgres psql -U username -d dbt_test -a -f var/scripts/select.sql

stop: ## Stop all or c=<name> containers
	docker exec -it dbtpostgres psql -U username -d dbt_test -a -f var/scripts/teardown.sql
	docker exec -it dbtpostgres psql -U username -d dbt_test -a -f var/scripts/select.sql
	docker compose --project-name dbttest -f $(DOCKER_COMPOSE_FILE) stop $(c)

status: ## Show status of containers
	docker compose --project-name dbttest -f $(DOCKER_COMPOSE_FILE) ps

logs: ## Show logs for all or c=<name> containers
	docker compose --project-name dbttest -f $(DOCKER_COMPOSE_FILE) logs --tail=100 -f $(c)

add-dbt-tbls:
	CURRENT_HOST=$(grep host profiles.yml)
	NEW_HOST=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dbtpostgres)
	NEW_HOST_STRING="      host: $(new_HOST)"
	sed -i '' -e "s/$CURRENT_HOST/$NEW_HOST_STRING/g" profiles.yml
	docker compose --project-name dbttest run dbt build

dbt-compile:
	docker compose --project-name dbttest run dbt compile
