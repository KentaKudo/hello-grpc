package api

import (
	"context"
	"fmt"
)

type Server struct{}

func (s *Server) SayHello(ctx context.Context, in *HelloRequest) (*HelloResponse, error) {
	return &HelloResponse{Message: fmt.Sprintf("Hello, %s!", in.Name)}, nil
}
