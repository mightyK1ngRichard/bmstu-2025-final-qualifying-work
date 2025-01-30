package cake

import (
	"2025_CakeLand_API/internal/pkg/cake"
	"2025_CakeLand_API/internal/pkg/cake/delivery/grpc/generated"
	"context"
	"log/slog"
)

type GrpcCakeHandler struct {
	generated.UnimplementedCakeServiceServer

	log     *slog.Logger
	usecase cake.ICakeUsecase
}

func NewCakeHandler(logger *slog.Logger, uc cake.ICakeUsecase) *GrpcCakeHandler {
	return &GrpcCakeHandler{
		log:     logger,
		usecase: uc,
	}
}

func (h *GrpcCakeHandler) Cake(ctx context.Context, req *generated.CakeRequest) (*generated.CakeResponse, error) {

	return nil, nil
}
