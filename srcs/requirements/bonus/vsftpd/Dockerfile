# syntax=docker/dockerfile:1

FROM alpine:3.21

RUN apk add --no-cache vsftpd

WORKDIR /etc

COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY tools/entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

EXPOSE 21 21000

ENTRYPOINT ["./entrypoint.sh"]

CMD ["vsftpd", "/etc/vsftpd/vsftpd.conf"]
