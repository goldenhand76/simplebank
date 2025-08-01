killpostgres:
	docker kill postgres 
	docker rm postgres

network:
	docker network create bank-network

postgres:
	docker run --name postgres --network bank-network --restart always -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb:
	docker exec -it postgres createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres dropdb simple_bank

run:
	docker rm simplebank || true
	docker run --name simplebank --network bank-network -p 8080:8080 -e GIN_MODE=release -e DB_SOURCE="postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" goldenhand/simplebank:latest
	
new_migration:
	migrate create -ext sql -dir db/migration -seq $(name)

migrateup:
	migrate -path ./db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path ./db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

test :
	go test -v -cover ./...
	
format:
	go fmt ./...
	
server :
	go run main.go

mock : 
	mockgen -destination db/mock/store.go -package mockdb simplabank/db/sqlc Store	

proto :
	rm -f pb/*.go
	rm -f doc/swagger/*.swagger.json
	protoc --proto_path=proto --go_out=pb --go_opt=paths=source_relative \
    --go-grpc_out=pb --go-grpc_opt=paths=source_relative \
	--grpc-gateway_out=pb --grpc-gateway_opt paths=source_relative \
	--openapiv2_out=doc/swagger --openapiv2_opt=allow_merge=true,merge_file_name=simple_bank \
    proto/*.proto 
	statik -src=./doc/swagger -dest=./doc

evans :
	evans --host localhost --port 9090 -r repl

.PHONY: postgres createdb dropdb proto evans