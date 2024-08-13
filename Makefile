killpostgres:
	docker kill postgres 
	docker rm postgres

postgres:
	docker run --name postgres --network bank-network --restart always -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

run:
	docker run --name simplebank --network bank-network -p 8080:8080 -e GIN_MODE=release -e DB_SOURCE="postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" goldenhand/simplebank:latest
	
createdb:
	docker exec -it postgres createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres dropdb simple_bank

migrateup:
	migrate -path ./db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path ./db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

test :
	go test -v -cover ./...
	
server :
	go run main.go

mock : 
	mockgen -destination db/mock/store.go -package mockdb simplabank/db/sqlc Store	


.PHONY: postgres createdb dropdb