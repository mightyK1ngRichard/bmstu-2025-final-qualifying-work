package cake

import (
	"2025_CakeLand_API/internal/pkg/cake/repo"
	"2025_CakeLand_API/internal/pkg/cake/usecase/models"
	"context"
)

type ICakeUsecase interface {
	Cake(context.Context, models.GetCakeReq) (*models.GetCakeRes, error)
}

type ICakeRepository interface {
	GetCakeByID(context.Context, repo.GetCakeReq) (*repo.GetCakesRes, error)
}
