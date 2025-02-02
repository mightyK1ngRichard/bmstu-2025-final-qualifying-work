package usecase

import (
	"2025_CakeLand_API/internal/models"
	"2025_CakeLand_API/internal/pkg/cake"
	"2025_CakeLand_API/internal/pkg/cake/repo"
	umodels "2025_CakeLand_API/internal/pkg/cake/usecase/models"
	"2025_CakeLand_API/internal/pkg/utils/sl"
	"context"
	"fmt"
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

func (u *CakeUseсase) Cake(ctx context.Context, in umodels.GetCakeReq) (*umodels.GetCakeRes, error) {
	res, err := u.repo.GetCakeByID(ctx, repo.GetCakeReq{
		CakeID: in.CakeID,
	})
	if err != nil {
		u.log.Error("[Usecase.Cake] ошибка получения торта по id из бд",
			slog.String("cakeID", fmt.Sprintf("%s", in.CakeID)),
			sl.Err(err),
		)
		return nil, models.NotFound
	}

	return &umodels.GetCakeRes{
		Cake: res.Cake,
	}, nil
}
