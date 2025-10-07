# Docker Notes

## Bind/mount volumes
```bash
docker run -v "$(pwd)/output.log:/usr/projet/PmergeMe.log" container_qui_exec_PmergeMe
```

Here we started a container executing a PmergeMe program that sends its output to a file `PmergeMe.log`. We've mounted a local file `$(pwd)/output.log` on the container program output file.
Any changes on one of those two files will affect the other one. They are technically the same.

## Port Management

Opening port this way: `<host_port>:<container_port>` → 8080:80 for example will in reality open 0.0.0.0:8080:80.
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

TO DO

## docker-compose file potential modifications




- rename wp-superadmin-user.txt file + change credentials
- nginx default.conf file -> maybe delete some, everything is not interesting and/or useful


### Implementation choices


[Funny documentation about HTML/TLS](https://howhttps.works/https-ssl-tls-differences/)


REDIS CACHE:

https://hub.docker.com/_/redis
https://redis.io/docs/latest/operate/oss_and_stack/management/security/
https://redis.io/docs/latest/operate/oss_and_stack/install/install-stack/docker/
https://medium.com/@praveenr801/introduction-to-redis-cache-using-docker-container-2e4e2969ed3f
https://github.com/rhubarbgroup/redis-cache/#configuration
https://wordpress.org/plugins/redis-cache/#description and underlyings



cAdvisor: port 4194

top choice
https://mobisoftinfotech.com/resources/blog/docker-container-monitoring-prometheus-grafana

second choice
https://belginux.com/monitoring-docker-grafana-prometheus-cadvisor/



NOTE: need to check more about that

echo "vm.overcommit_memory=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

> Redis needs this setting to allow the kernel to allocate more memory than physically available to ensure background saving (RDB snapshots) or replication can work reliably even under memory pressure.

> Explanation of Memory Overcommit

> Memory Overcommit determines how the Linux kernel handles memory allocation requests that exceed total available RAM.

> When set to 0 (default), the kernel is conservative and may deny allocations that exceed physical RAM, which can cause Redis background processes to fail.

> When set to 1, the kernel allows allocating more memory than physically available, improving Redis reliability during operations needing extra memory temporarily.



Prometheus/Grafana/cAdvisor:

https://mobisoftinfotech.com/resources/blog/docker-container-monitoring-prometheus-grafana
https://www.virtana.com/glossary/what-is-a-tar-cadvisor-container-advisor/#:~:text=cAdvisor%20(Container%20Advisor)%20is%20an,performance%20metrics%20from%20running%20containers.
https://signoz.io/guides/how-to-install-prometheus-and-grafana-on-docker/ -> looks fucking amazing for the whole


https://hub.docker.com/r/google/cadvisor
https://github.com/google/cadvisor
https://ipv6.rs/tutorial/Alpine_Linux_Latest/cadvisor/ -> good
https://github.com/google/cadvisor/blob/master/docs/storage/prometheus.md -> check other readme aswell

![test](https://github.com/AzehLM/Inception/blob/main/excalidraw.png)
