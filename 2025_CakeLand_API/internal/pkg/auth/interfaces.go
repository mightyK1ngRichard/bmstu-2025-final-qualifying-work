package auth

import (
	"2025_CakeLand_API/internal/models"
	"context"
)

type IAuthUsecase interface {
	Register(context.Context, models.RegisterUser) (string, error)
	Login(context.Context, models.LoginUser) (string, error)
	//Logout(context.Context, *generatedAuth.LogoutRequest) (*generatedAuth.LogoutResponse, error)
}

type IAuthRepository interface {
}
