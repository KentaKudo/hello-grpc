package main

import (
	"fmt"
	"log"
	"net"

	"github.com/KentaKudo/hello-grpc/api"
	"google.golang.org/grpc"
)

func main() {
	// listen on port 9090
	lis, err := net.Listen("tcp", fmt.Sprintf(":%d", 9090))
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	// create a server
	s := api.Server{}
	grpcServer := grpc.NewServer()

	// register Server has GreeterServer
	api.RegisterGreeterServer(grpcServer, &s)

	// start serving
	if err := grpcServer.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
