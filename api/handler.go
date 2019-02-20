package api

import (
	"context"
	"fmt"
	"log"
)

type Server struct{}

func (s *Server) SayHello(ctx context.Context, in *HelloRequest) (*HelloResponse, error) {
	log.Printf("request from client: %s", in.Name)
	return &HelloResponse{Message: fmt.Sprintf("Hello, %s!", in.Name)}, nil
}
