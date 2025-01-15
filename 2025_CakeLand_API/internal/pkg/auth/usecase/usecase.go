package usecase

import (
	"2025_CakeLand_API/internal/models"
	"2025_CakeLand_API/internal/pkg/auth"
	"context"
	"fmt"
	"log/slog"
)

type AuthUseсase struct {
	log  *slog.Logger
	repo auth.IAuthRepository
}

func NewAuthUsecase(log *slog.Logger, repo auth.IAuthRepository) *AuthUseсase {
	return &AuthUseсase{
		log:  log,
		repo: repo,
	}
}

func (u *AuthUseсase) Login(ctx context.Context, user models.LoginUser) (string, error) {
	return fmt.Sprintf("token for email: %s", user.Email), nil
}

func (u *AuthUseсase) Register(ctx context.Context, user models.RegisterUser) (string, error) {
	return fmt.Sprintf("registered token for user: %s", user.Email), nil
}
