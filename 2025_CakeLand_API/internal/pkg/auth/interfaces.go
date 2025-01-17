package auth

import (
	"2025_CakeLand_API/internal/models"
	"context"
	"github.com/google/uuid"
)

type IAuthUsecase interface {
	Register(context.Context, models.UCRegisterUserReq) (*models.UCLoginResponse, error)
	Login(context.Context, models.UCLoginUser) (*models.UCLoginResponse, error)
	//Logout(context.Context, *generatedAuth.LogoutRequest) (*generatedAuth.LogoutResponse, error)
}

type IAuthRepository interface {
	CreateUser(context.Context, models.RepUserReq) error
	GetUserByEmail(context.Context, string) (*models.User, error)
	UpdateUserRefreshTokens(ctx context.Context, userID uuid.UUID, refreshTokensMap map[string]string) error
	//InsertRefreshToken(context.Context, uuid.UUID, models.JWTTokenPayload) error
}
