
FROM golang:1.20 AS builder
WORKDIR /app
COPY . .
RUN go build -o app main.go
FROM mysql:8.0
WORKDIR /root

ENV MYSQL_ROOT_PASSWORD=password
ENV MYSQL_DATABASE=exampledb

RUN mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql && mysqld --initialize-insecure --user=mysql

RUN echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password'; FLUSH PRIVILEGES;" > /docker-entrypoint-initdb.d/init.sql

COPY --from=builder /app/app /usr/local/bin/app

EXPOSE 3306

CMD ["bash", "-c", "mysqld --user=mysql & sleep 10 && /usr/local/bin/app"]

