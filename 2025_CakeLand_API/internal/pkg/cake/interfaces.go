package cake

import (
	"2025_CakeLand_API/internal/pkg/cake/repo"
	"context"
)

type ICakeUsecase interface {
}

type ICakeRepository interface {
	GetCakeByID(context.Context, repo.GetCakesListReq) (*repo.GetCakesListRes, error)
}
