SECRETS_PATH	:= secrets/ssl/
CERT_PATH		:= $(SECRETS_PATH)cert.pem
KEY_PATH		:= $(SECRETS_PATH)key.pem

COMPOSE_FILE	:= srcs/docker-compose.yml
COMPOSE_CMD		:= docker compose -f $(COMPOSE_FILE)

DATA_DIR		:= /home/gueberso/data
MARIADB_DIR		:= $(DATA_DIR)/mariadb
WORDPRESS_DIR	:= $(DATA_DIR)/wordpress

export DOCKER_BUILDKIT=1

.DEFAULT_GOAL	:= build

.PHONY: all
all: ssl dirs build up

dirs:
	@mkdir -p $(MARIADB_DIR)
	@mkdir -p $(WORDPRESS_DIR)

build: ssl dirs
	$(COMPOSE_CMD) build

# Start all services (build if necessary)
up: ssl dirs
	$(COMPOSE_CMD) up -d --build

# Stop all services without removing containers
stop:
	$(COMPOSE_CMD) stop

# Stop and remove containers, networks
down:
	$(COMPOSE_CMD) down

# Clean: stop and remove containers, networks, and anonymous volumes
clean: down
	$(COMPOSE_CMD) down -v
	@docker system prune -f

# Full clean: remove everything including images and named volumes
fclean: clean
	$(COMPOSE_CMD) down -v --rmi all
	@if [ -n "$$(docker volume ls -q)" ]; then \
		docker volume rm $$(docker volume ls -q) 2>/dev/null || true; \
	fi
	@if [ -n "$$(docker images -q)" ]; then \
		docker rmi -f $$(docker images -q) 2>/dev/null || true; \
	fi
	@docker system prune -a -f --volumes
	@sudo rm -rf $(DATA_DIR)

# Restart everything
re: down
	$(MAKE) build
	$(MAKE) up

# Show logs from all services
logs:
	$(COMPOSE_CMD) logs -f

# Show logs from a specific service (usage: make logs-service SERVICE=nginx)
logs-service:
	@if [ -z "$(SERVICE)" ]; then \
	else \
		docker-compose -f $(COMPOSE_FILE) logs -f $(SERVICE); \
	fi

# Show status of all services
status:
	$(COMPOSE_CMD) ps

# Enter a running container (usage: make exec SERVICE=nginx)
exec:
	@if [ -z "$(SERVICE)" ]; then \
		echo "Error: Please specify SERVICE. Usage: make exec SERVICE=nginx$(NC)"; \
	else \
		docker-compose -f $(COMPOSE_FILE) exec $(SERVICE) /bin/sh; \
	fi

restart:
	$(COMPOSE_FILE) restart


.PHONY: ssl
ssl: $(CERT_PATH) $(KEY_PATH)

$(CERT_PATH) $(KEY_PATH): | $(SECRETS_PATH)
	openssl req -x509 -newkey rsa:4096 -sha256 -days 365 -nodes \
	-subj "/C=EN/ST=France/L=Lyon/O=42Lyon/OU=DevOps/CN=$(DOMAIN)" \
	-keyout $(KEY_PATH) -out $(CERT_PATH)
