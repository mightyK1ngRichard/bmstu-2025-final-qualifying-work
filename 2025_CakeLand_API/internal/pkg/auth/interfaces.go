package auth

import (
	rmodels "2025_CakeLand_API/internal/pkg/auth/repo/models"
	umodels "2025_CakeLand_API/internal/pkg/auth/usecase/models"
	"context"
)

// mockgen -source=internal/pkg/auth/interfaces.go -destination=internal/pkg/auth/mocks/mock_auth.go -package=mocks

type IAuthUsecase interface {
	Register(context.Context, umodels.RegisterReq) (*umodels.RegisterRes, error)
	Login(context.Context, umodels.LoginReq) (*umodels.LoginRes, error)
	Logout(context.Context, umodels.LogoutReq) (*umodels.LogoutRes, error)
	UpdateAccessToken(context.Context, umodels.UpdateAccessTokenReq) (*umodels.UpdateAccessTokenRes, error)
}

type IAuthRepository interface {
	CreateUser(context.Context, rmodels.CreateUserReq) error
	GetUserByEmail(context.Context, rmodels.GetUserByEmailReq) (*rmodels.GetUserByEmailRes, error)
	UpdateUserRefreshTokens(context.Context, rmodels.UpdateUserRefreshTokensReq) error
	GetUserRefreshTokens(context.Context, rmodels.GetUserRefreshTokensReq) (*rmodels.GetUserRefreshTokensRes, error)
}
