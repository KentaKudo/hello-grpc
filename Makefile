SERVER_OUT := "bin/server"
CLIENT_OUT := "bin/client"
API_OUT := "api/api.pb.go"
PKG := "github.com/KentaKudo/hello-grpc"
SERVER_PKG := "${PKG}/server"
CLIENT_PKG := "${PKG}/client"

.PHONY: all api server client

all: server client

api/api.pb.go: api/api.proto
	@protoc -I api/ \
			-I${GOPATH}/src \
			--go_out=plugins=grpc:api \
			api/api.proto

api: api/api.pb.go ## Generate source code from .proto

deps: ## Resolve dependencies
	@go get -v -d ./...

server: deps api ## Build the server binary
	@go build -i -v -o $(SERVER_OUT) $(SERVER_PKG)

client: deps api ## Build the client binary
	@go build -i -v -o $(CLIENT_OUT) $(CLIENT_PKG)

clean: ## Remove the previous builds
	@rm $(API_OUT) $(SERVER_OUT) $(CLIENT_OUT)

help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'