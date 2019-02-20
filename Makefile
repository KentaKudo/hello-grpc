SERVER_OUT := "bin/server"
CLIENT_OUT := "bin/client"
WEB_GO_OUT := "bin/web"
WEB_OUT := "dist/main.js"
API_OUT_GO := "api/api.pb.go"
API_OUT_JS := "api/api_pb.js"
API_OUT_WEB_JS := "api/api_grpc_web_pb.js"
PKG := "github.com/KentaKudo/hello-grpc"
SERVER_PKG := "${PKG}/server"
CLIENT_PKG := "${PKG}/client"
WEB_GO_PKG := "${PKG}/web"

.PHONY: all api server client web

all: server client web

api/api.pb.go api/api_pb.js api/api_grpc_web_pb.js: api/api.proto
	@protoc -I api/ \
			-I${GOPATH}/src \
			--go_out=plugins=grpc:api \
			api/api.proto
	@protoc -I=. api/api.proto \
			--js_out=import_style=commonjs:. \
			--grpc-web_out=import_style=commonjs,mode=grpcwebtext:.

api: api/api.pb.go api/api_pb.js api/api_grpc_web_pb.js ## Generate source code from .proto

deps: ## Resolve dependencies
	@go get -v -d ./...
	@npm install

server: deps api ## Build the server binary
	@go build -i -v -o $(SERVER_OUT) $(SERVER_PKG)

client: deps api ## Build the client binary
	@go build -i -v -o $(CLIENT_OUT) $(CLIENT_PKG)

web: deps api ## Build the web files
	@npm run-script build
	@go build -i -v -o $(WEB_GO_OUT) $(WEB_GO_PKG)

clean: ## Remove the previous builds
	@rm $(API_OUT_GO) $(API_OUT_JS) $(API_OUT_WEB_JS) $(SERVER_OUT) $(CLIENT_OUT) $(WEB_OUT) $(WEB_GO_OUT)

help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'