package main

import (
	"context"
	"log"

	"github.com/KentaKudo/hello-grpc/api"
	"google.golang.org/grpc"
)

func main() {
	// dial and connect
	conn, err := grpc.Dial(":8080", grpc.WithInsecure())
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()

	// create a client from the connection
	c := api.NewGreeterClient(conn)

	// call the SayHello RPC
	req := &api.HelloRequest{Name: "World"}
	response, err := c.SayHello(context.Background(), req)
	if err != nil {
		log.Fatalf("error when calling SayHello: %v", err)
	}

	log.Printf("response from server: %v", response.Message)
}
