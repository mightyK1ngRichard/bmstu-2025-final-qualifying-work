package main

import (
	cake "2025_CakeLand_API/internal/pkg/cake/delivery/grpc"
	"2025_CakeLand_API/internal/pkg/cake/delivery/grpc/generated"
	"2025_CakeLand_API/internal/pkg/cake/repo"
	"2025_CakeLand_API/internal/pkg/cake/usecase"
	"2025_CakeLand_API/internal/pkg/config"
	"2025_CakeLand_API/internal/pkg/utils"
	"2025_CakeLand_API/internal/pkg/utils/logger"
	"fmt"
	_ "github.com/lib/pq"
	"google.golang.org/grpc"
	"log/slog"
	"net"
	"os"
)

// go run cmd/cake/main.go --config=./config/localConfig.yaml
func main() {
	if err := run(); err != nil {
		fmt.Print(err)
		os.Exit(1)
	}
}

func run() error {
	// Создаём Configuration
	conf, err := config.NewConfig()
	if err != nil {
		return err
	}
	// Создаём Logger
	log := logger.NewLogger(conf.Env)
	// Подключаем базу данных
	db, err := utils.ConnectPostgres(conf)
	if err != nil {
		return err
	}

	// Создаём grpc сервис
	listener, err := net.Listen("tcp", fmt.Sprintf(":%d", conf.GRPC.Port))
	if err != nil {
		return err
	}
	grpcServer := grpc.NewServer()
	repo := repo.NewCakeRepository(db)
	usecase := usecase.NewCakeUsecase(log, repo)
	handler := cake.NewCakeHandler(log, usecase)
	generated.RegisterCakeServiceServer(grpcServer, handler)
	log.Info("Starting gRPC cake service", slog.String("port", fmt.Sprintf(":%d", conf.GRPC.Port)))
	return grpcServer.Serve(listener)
}
