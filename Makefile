DOMAIN			:= gueberso.42.fr

SECRETS_PATH	:= secrets/ssl/
CERT_PATH		:= $(SECRETS_PATH)cert.pem
KEY_PATH		:= $(SECRETS_PATH)key.pem

COMPOSE_FILE	:= srcs/docker-compose.yml
COMPOSE_CMD		:= docker compose -f $(COMPOSE_FILE)

DATA_DIR		:= /home/gueberso/data
MARIADB_DIR		:= $(DATA_DIR)/mariadb
WORDPRESS_DIR	:= $(DATA_DIR)/wordpress

export DOCKER_BUILDKIT=1

.DEFAULT_GOAL	:= up

.PHONY: dirs
dirs:
	@mkdir -p $(MARIADB_DIR)
	@mkdir -p $(WORDPRESS_DIR)

.PHONY: build
build: $(CERT_PATH) $(KEY_PATH) dirs
	$(COMPOSE_CMD) build

.PHONY: up
up: $(CERT_PATH) $(KEY_PATH) dirs
	$(COMPOSE_CMD) up -d

.PHONY: stop
stop:
	$(COMPOSE_CMD) stop

.PHONY: down
down:
	$(COMPOSE_CMD) down

.PHONY: clean
clean: down
	$(COMPOSE_CMD) down -v
	@docker system prune -f

.PHONY: fclean
fclean: clean
	$(COMPOSE_CMD) down -v --rmi all
	@if [ -n "$$(docker volume ls -q)" ]; then \
		docker volume rm $$(docker volume ls -q) 2>/dev/null || true; \
	fi
	@if [ -n "$$(docker images -q)" ]; then \
		docker rmi -f $$(docker images -q) 2>/dev/null || true; \
	fi
	@docker system prune -af --volumes
	@rm -rf $(SECRETS_PATH)*
	@sudo rm -rf $(DATA_DIR)

.PHONY: re
re: down
	$(MAKE) build
	$(MAKE) up

.PHONY: logs
logs:
	$(COMPOSE_CMD) logs

.PHONY: logs-service
logs-service:
	@if [ -z "$(word 2,$(MAKECMDGOALS))" ]; then \
		echo "Error: Please specify service. Usage: make logs-service service_name"; \
	else \
		docker compose -f $(COMPOSE_FILE) logs $(word 2,$(MAKECMDGOALS)); \
	fi

.PHONY: exec
exec:
	@if [ -z "$(word 2,$(MAKECMDGOALS))" ]; then \
		echo "Error: Please specify SERVICE. Usage: make exec service_name"; \
	else \
		docker compose -f $(COMPOSE_FILE) exec $(SERVICE) /bin/sh; \
	fi

.PHONY: status
status:
	$(COMPOSE_CMD) ps

.PHONY: restart
restart:
	$(COMPOSE_FILE) restart


.PHONY: ssl
ssl: $(CERT_PATH) $(KEY_PATH)

$(CERT_PATH) $(KEY_PATH): | $(SECRETS_PATH)
	@openssl req -x509 -newkey rsa:4096 -sha256 -days 365 -nodes \
	-subj "/C=FR/ST=France/L=Lyon/O=42Lyon/OU=DevOps/CN=$(DOMAIN)" \
	-keyout $(KEY_PATH) -out $(CERT_PATH)


# For any target not explicitly defined elsewhere, do nothing and consider it successful.
# Define dummy targets for any argument passed to logs-service and exec, to prevent Make errors
%:
	@:
