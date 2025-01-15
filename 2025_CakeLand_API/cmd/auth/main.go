package main

import (
	"2025_CakeLand_API/internal/pkg/auth/delivery/grpc"
	generatedAuth "2025_CakeLand_API/internal/pkg/auth/delivery/grpc/generated"
	"2025_CakeLand_API/internal/pkg/auth/repo/postgres"
	"2025_CakeLand_API/internal/pkg/auth/usecase"
	"2025_CakeLand_API/internal/pkg/config"
	"2025_CakeLand_API/internal/pkg/lib/logger"
	"fmt"
	"google.golang.org/grpc"
	"log/slog"
	"net"
	"os"
)

// go run cmd/auth/main.go --config=./config/config.yaml
func main() {
	if err := run(); err != nil {
		fmt.Print(err)
		os.Exit(1)
	}
}

func run() error {
	// Получаем Configuration
	conf, err := config.NewConfig()
	if err != nil {
		return err
	}

	// Создаём Logger
	log := logger.NewLogger(conf.Env)

	// Создаём grpc сервис
	listener, err := net.Listen("tcp", fmt.Sprintf(":%d", conf.GRPC.Port))
	if err != nil {
		return err
	}
	grpcServer := grpc.NewServer()
	repo := postgres.NewAuthRepository()
	authUsecase := usecase.NewAuthUsecase(log, repo)
	grpcAuthHandler := grpcAuth.NewGrpcAuthHandler(authUsecase)
	generatedAuth.RegisterAuthServer(grpcServer, grpcAuthHandler)
	log.Info("Starting gRPC server", slog.String("port", fmt.Sprintf(":%d", conf.GRPC.Port)))
	return grpcServer.Serve(listener)
}
