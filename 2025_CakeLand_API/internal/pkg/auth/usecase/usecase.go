package usecase

import (
	"2025_CakeLand_API/internal/models"
	"2025_CakeLand_API/internal/pkg/auth"
	"context"
	"fmt"
	"golang.org/x/crypto/bcrypt"
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

func (u *AuthUseсase) Login(ctx context.Context, user models.UCLoginUser) (string, error) {
	return fmt.Sprintf("token for email: %s", user.Email), nil
}

func (u *AuthUseсase) Register(ctx context.Context, user models.UCRegisterUserReq) (*models.UCRegisterUserRes, error) {
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.MinCost)
	if err != nil {
		return nil, err
	}
	createdUserUID, err := u.repo.CreateUser(ctx, models.RepUser{
		Email:        user.Email,
		PasswordHash: hashedPassword,
	})
	if err != nil {
		u.log.Error(fmt.Sprintf("ошибка создания пользователя: %v", err))
		return nil, err
	}
	u.log.Info(fmt.Sprintf("Создался пользователь с uid: %s", createdUserUID))

	return &models.UCRegisterUserRes{
		UserUID: createdUserUID,
	}, nil
}
