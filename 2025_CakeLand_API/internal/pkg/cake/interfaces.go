package cake

import (
	"2025_CakeLand_API/internal/pkg/cake/repo"
	"2025_CakeLand_API/internal/pkg/cake/usecase"
	"context"
)

type ICakeUsecase interface {
	Cake(context.Context, usecase.GetCakeReq) (*usecase.GetCakeRes, error)
}

type ICakeRepository interface {
	GetCakeByID(context.Context, repo.GetCakeReq) (*repo.GetCakesRes, error)
}
