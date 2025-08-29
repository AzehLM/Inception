# Smaller than Ubuntu or Debian but no fancy tools
FROM alpine:3.21

# The following instructions will be executed in this location.
WORKDIR /usr/src/app

# Copy the hello.sh file from this directory to /usr/src/app/ creating /usr/src/app/hello.sh
COPY hello.sh .

# Alternatively, if we skipped chmod earlier, we can add execution permissions during the build.
RUN chmod +x hello.sh
RUN touch additional.txt

# When running docker run the command will be ./hello.sh
CMD ["./hello.sh"]
