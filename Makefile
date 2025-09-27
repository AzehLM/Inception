export DOCKER_BUILDKIT=1

COMPOSE_FILE	:= srcs/docker-compose.yml
COMPOSE_CMD		:= docker compose -f $(COMPOSE_FILE)

DOMAIN_NAME		:= gueberso.42.fr

DATA_DIR		:= $(HOME)/data/
MARIADB_DIR		:= $(DATA_DIR)mariadb
WORDPRESS_DIR	:= $(DATA_DIR)wordpress

VOLUMES 		:= \
	mariadb \
	wordpress \

$(MARIADB_DIR):
	mkdir -p $@

$(WORDPRESS_DIR):
	mkdir -p $@

SECRETS_PATH	:= secrets/ssl/
CERT_PATH		:= $(SECRETS_PATH)cert.pem
KEY_PATH		:= $(SECRETS_PATH)key.pem

$(SECRETS_PATH):
	mkdir -p $@

$(CERT_PATH) $(KEY_PATH): | $(SECRETS_PATH)
	@openssl req -x509 -newkey rsa:4096 -sha256 -days 365 -nodes \
	-subj "/C=FR/ST=France/L=Lyon/O=42Lyon/OU=DevOps/CN=$(DOMAIN_NAME)" \
	-keyout $(KEY_PATH) -out $(CERT_PATH)

.DEFAULT_GOAL	:= up

.PHONY: dirs
dirs: $(MARIADB_DIR) $(WORDPRESS_DIR)

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
	docker system prune -af
	docker volume rm $(VOLUMES) || true

.PHONY: fclean
fclean: clean
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
		echo "Error: Please specify service. Usage: make logs-service <service_name>"; \
	else \
		$(COMPOSE_CMD) logs $(word 2,$(MAKECMDGOALS)); \
	fi

.PHONY: exec
exec:
	@if [ -z "$(word 2,$(MAKECMDGOALS))" ]; then \
		echo "Error: Please specify SERVICE. Usage: make exec <service_name>"; \
	else \
		$(COMPOSE_CMD) exec $(word 2,$(MAKECMDGOALS)) sh; \
	fi

.PHONY: ssl
ssl: $(CERT_PATH) $(KEY_PATH)

# For any target not explicitly defined elsewhere, do nothing and consider it successful.
# Define dummy targets for any argument passed to logs-service and exec, to prevent Make errors
%:
	@:
