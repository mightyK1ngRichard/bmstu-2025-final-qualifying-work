package auth

import (
	"2025_CakeLand_API/internal/models"
	"context"
	"github.com/google/uuid"
)

type IAuthUsecase interface {
	Register(context.Context, models.UCRegisterUserReq) (*models.UCRegisterUserRes, error)
	Login(context.Context, models.UCLoginUser) (string, error)
	//Logout(context.Context, *generatedAuth.LogoutRequest) (*generatedAuth.LogoutResponse, error)
}

type IAuthRepository interface {
	CreateUser(context.Context, models.RepUser) (uuid.UUID, error)
}
