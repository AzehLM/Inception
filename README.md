# Ressources

### Learn docker

- [Full course #1](https://courses.mooc.fi/org/uh-cs/courses/devops-with-docker)
- [Full course #2](https://github.com/sidpalas/devops-directive-docker-course)
- [dockerdocs (everything you need is here)](https://docs.docker.com/)

### Specific documentation

- [WP-CLI Commands](https://developer.wordpress.org/cli/commands/)
- [Mariadb](https://mariadb.com/docs/server/mariadb-quickstart-guides/installing-mariadb-server-guide)
- [nginx](https://nginx.org/en/docs/)

#### Bonuses

- [Redis](https://redis.io/docs/latest/operate/oss_and_stack/install/install-stack/docker/)
- [Redis config](https://github.com/rhubarbgroup/redis-cache?tab=readme-ov-file#redis-object-cache-for-wordpress)
- [Adminer](https://hub.docker.com/_/adminer/)
- [vsftpd (french documentation)](https://doc.ubuntu-fr.org/vsftpd)

#### cAdvisor/Prometheus/Grafana

- [cAdvisor](https://www.virtana.com/glossary/what-is-a-tar-cadvisor-container-advisor/#:~:text=cAdvisor%20(Container%20Advisor)%20is%20an,performance%20metrics%20from%20running%20containers)
- [cAdvisor dockerhub](https://hub.docker.com/r/google/cadvisor)
- [How to set up Prometheus and Grafana](https://signoz.io/guides/how-to-install-prometheus-and-grafana-on-docker/)
- [Practical Example](https://mobisoftinfotech.com/resources/blog/docker-container-monitoring-prometheus-grafana)
- [cAdvisor/Prometheus metrics](https://github.com/google/cadvisor/blob/master/docs/storage/prometheus.md)

> Most of those links have redirection to configurations instructions


# Diagram of the final project with personal bonuses

![diagram](https://github.com/AzehLM/Inception/blob/main/assets/diagram.png)

# Setup Instructions

## Directory Structure

After cloning the repository, you'll need to create the secrets directory and configuration files. Here's what the final structure should look like:

```
.
├── Makefile
├── README.md
├── secrets/
│   ├── grafana/
│   │   ├── grafana_admin_password.txt
│   │   └── grafana_admin_user.txt
│   ├── mariadb/
│   │   ├── mariadb_database.txt
│   │   ├── mariadb_password.txt
│   │   ├── mariadb_root_password.txt
│   │   └── mariadb_user.txt
│   ├── vsftpd/
│   │   ├── ftp_password.txt
│   │   └── ftp_user.txt
│   └── wordpress/
│       ├── wp_admin.txt
│       └── wp_public_user_password.txt
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
```
> The SSL certificate will be generated at the first build and placed in the secrets directory aswell.

---

# Notes

Those notes have been made during my learning process, most of those informations might be very specific to question I asked myself at some point while reading documentation or **were** my understanding of what I just read.

## Port Management

Opening port this way: `<host_port>:<container_port>` → 8080:80 will in reality open 0.0.0.0:8080:80.
This could result in a security breach.

## PID 1

There are fundamental differences between a Linux system and a container.

In a Linux system, the PID 1 is the one booting the system (`systemd`, `SysV init`, ...) and it has two responsibilities:
- Parent process of any orphan process
- Act as a reaping process: it reaps any zombie processes.

In a container, either the `CMD` or the `ENTRYPOINT` becomes the PID 1 of its container.
The command executed as PID 1 has to be designed to handle the responsibilities of a PID1 process.

The subject forbids `tail -f /dev/null` and so on is here to prevent us having commands not designed as PID 1 processes. By definition, containers are not VMs, these are process isolating environments.

## Difference of execution between JSON/shell format
- Exec(JSON) format: `CMD ["cmd", "json", "format"]` → Docker uses `execve()` with the args: CMD ["command"] → **(PID 1 = command)**
- Shell format: `CMD "cmd"` → Docker does `/bin/sh -c` then gives it the command as arg: CMD "cmd" → `/bin/sh -c cmd` **(PID 1 = sh)**

## Reasons behind the choice of design of Docker
- Inheritance and compatibility → principle of `least surprise`: by convention, we give a string to an executing process, traditionally interpreted by a shell.

- Two distinct usages:
	- Shell format: simplicity, use of native functionalities of a shell (piping, variables, env, ...), compatibility with existing scripts. Few or no management by the dev.
	- Exec format: Total control over signals, performances, predictability...

## CGI (Common Gateway Interface)

A standard allowing the communication between an HTTP server and external processes. Allows the web server to interact with different programming languages. It is an interface standardizing the transmission of requests between a web server and dynamic applications.

## PHP-FPM

Alternative to FastCGI.
It creates a pool of PHP processes. When it gets a request, PHP-FPM chooses the available processes from the pool to handle the request.
Different types of processes:
- Master process: responsible for the management of the pool processes. It listens to the incoming requests and distributes them.
- Worker processes: responsible for the execution of PHP scripts. Can run dynamically, statically or on demand. When a worker receives a request, it executes the PHP scripts and returns the output to the web server.

## Proxy / Reverse Proxy

- What is a proxy ?

It is a intermediary between clients (web browsers) and servers. For Inception, nginx is acting as **reverse proxy**, it receives requests and forwards them to our services.
Why do we need that here ? nginx handles SSL/TLS encryption by listening




[Funny documentation about HTML/TLS](https://howhttps.works/https-ssl-tls-differences/)



```bash
echo "vm.overcommit_memory=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

Redis needs this setting to allow the kernel to allocate more memory than physically available to ensure background saving (RDB snapshots) or replication can work reliably even under memory pressure.

**Explanation of Memory Overcommit:**
- Memory Overcommit determines how the Linux kernel handles memory allocation requests that exceed total available RAM.
- When set to 0 (default), the kernel is conservative and may deny allocations that exceed physical RAM, which can cause Redis background processes to fail.
- When set to 1, the kernel allows allocating more memory than physically available, improving Redis reliability during operations needing extra memory temporarily.




# Dump notions and usage (not detailed)

## Health Checks
**What it is**: Built-in monitoring to ensure containers are actually working, not just running.

```yaml
# In docker-compose.yml
services:
  nginx:
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:x/"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
```

## Multi-Stage Builds
**What it is**: Use multiple FROM statements to create optimized, smaller final images.

```dockerfile
# Build stage
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Production stage
FROM node:18-alpine AS production
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

**Benefits**: Smaller images, better security (no build tools in production), faster deployments.

## Docker Secrets & Security
**What it is**: Secure way to handle sensitive data without embedding in images.

```yaml
# docker-compose.yml
services:
  db:
    image: postgres
    secrets:
      - db_password
    environment:
      POSTGRES_PASSWORD_FILE: /run/secrets/db_password

secrets:
  db_password:
    file: ./secrets/db_password.txt
```

## Advanced Networking
**What it is**: Custom networks for service isolation and communication.

```yaml
services:
  frontend:
    networks:
      - web-tier

  backend:
    networks:
      - web-tier
      - database-tier

  database:
    networks:
      - database-tier

networks:
  web-tier:
    driver: bridge
  database-tier:
    internal: true  # No external access
```

## Container Communication Patterns

```yaml
# Service dependencies with conditions
services:
  web:
    depends_on:
      db:
        condition: service_healthy
        restart: true

  db:
    healthcheck:
      test: ["CMD", "pg_isready", "-U", "postgres"]
```
