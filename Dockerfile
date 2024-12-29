# Stage 1: Build the Go app
FROM golang:1.20 AS builder
WORKDIR /app
COPY . .
RUN go build -o app main.go

# Stage 2: Final image with MySQL and Go app
FROM mysql:8.0
WORKDIR /root

# Environment variables for MySQL
ENV MYSQL_ROOT_PASSWORD=password
ENV MYSQL_DATABASE=exampledb

# Initialize MySQL data directory
RUN mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql && mysqld --initialize-insecure --user=mysql

# Allow root to connect from any host
RUN echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password'; FLUSH PRIVILEGES;" > /docker-entrypoint-initdb.d/init.sql

# Copy the Go app into the image
COPY --from=builder /app/app /usr/local/bin/app

# Expose MySQL port
EXPOSE 3306

# Start MySQL and run the Go app
CMD ["bash", "-c", "mysqld --user=mysql & sleep 10 && /usr/local/bin/app"]

