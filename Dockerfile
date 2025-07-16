# Build Stage
FROM golang:1.22.1-alpine3.18 AS builder
WORKDIR /app
COPY . .
RUN go build -o main main.go
RUN apk add curl
RUN curl -L https://github.com/golang-migrate/migrate/releases/download/v4.12.2/migrate.linux-amd64.tar.gz | tar xvz

# RUN Stage
FROM alpine:3.18
WORKDIR /app
COPY --from=builder /app/main .
COPY --from=builder /app/migrate.linux-amd64 ./migrate
COPY app.env .
COPY start.sh .
COPY db/migration ./migration

RUN chmod +x /app/start.sh /app/main /app/migrate
RUN sed -i 's/\r$//' /app/start.sh     # fix Windows line endings

EXPOSE 8080
ENTRYPOINT [ "/app/start.sh" ]
CMD [ "/app/main" ]