package usecase

import (
	"2025_CakeLand_API/internal/pkg/cake"
	"log/slog"
)

type CakeUseсase struct {
	log  *slog.Logger
	repo cake.ICakeRepository
}

func NewCakeUsecase(log *slog.Logger, repo cake.ICakeRepository) *CakeUseсase {
	return &CakeUseсase{
		log:  log,
		repo: repo,
	}
}
