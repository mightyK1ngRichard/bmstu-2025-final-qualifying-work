package auth

import (
	"2025_CakeLand_API/internal/pkg/auth/repo"
	umodels "2025_CakeLand_API/internal/pkg/auth/usecase/models"
	"context"
)

type IAuthUsecase interface {
	Register(context.Context, umodels.RegisterReq) (*umodels.RegisterRes, error)
	Login(context.Context, umodels.LoginReq) (*umodels.LoginRes, error)
}

type IAuthRepository interface {
	CreateUser(context.Context, repo.CreateUserReq) error
	GetUserByEmail(context.Context, repo.GetUserByEmailReq) (*repo.GetUserByEmailRes, error)
	UpdateUserRefreshTokens(context.Context, repo.UpdateUserRefreshTokensReq) error
}
