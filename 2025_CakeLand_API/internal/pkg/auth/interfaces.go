package auth

import (
	"2025_CakeLand_API/internal/pkg/auth/repo"
	umodels "2025_CakeLand_API/internal/pkg/auth/usecase/models"
	"context"
)

type IAuthUsecase interface {
	Register(context.Context, umodels.RegisterReq) (*umodels.RegisterRes, error)
	Login(context.Context, umodels.LoginReq) (*umodels.LoginRes, error)
	Logout(context.Context, umodels.LogoutReq) (*umodels.LogoutRes, error)
	UpdateAccessToken(context.Context, umodels.UpdateAccessTokenReq) (*umodels.UpdateAccessTokenRes, error)
}

type IAuthRepository interface {
	CreateUser(context.Context, repo.CreateUserReq) error
	GetUserByEmail(context.Context, repo.GetUserByEmailReq) (*repo.GetUserByEmailRes, error)
	UpdateUserRefreshTokens(context.Context, repo.UpdateUserRefreshTokensReq) error
	GetUserRefreshTokens(context.Context, repo.GetUserRefreshTokensReq) (*repo.GetUserRefreshTokensRes, error)
}
