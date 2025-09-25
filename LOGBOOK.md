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


## docker-compose file potential modifications

- nginx
    - ports: 127.0.0.1:443:443
	- volumes: :ro pour read-only


- rename wp-superadmin-user.txt file + change credentials
