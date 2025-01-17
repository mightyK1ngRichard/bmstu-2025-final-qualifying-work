package usecase

import (
	"2025_CakeLand_API/internal/models"
	"2025_CakeLand_API/internal/pkg/auth"
	"2025_CakeLand_API/internal/pkg/utils/jwt"
	"context"
	"fmt"
	"github.com/google/uuid"
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

func (u *AuthUseсase) Login(ctx context.Context, user models.UCLoginUser) (*models.UCLoginResponse, error) {
	// Получаем данные пользователя
	resUser, err := u.repo.GetUserByEmail(ctx, user.Email)
	if err != nil {
		u.log.Error(fmt.Sprintf("Ошибка получения пользователя по email: %v", err))
		return nil, err
	}

	accessToken, err := jwt.GenerateAccessToken(resUser.ID.String())
	if err != nil {
		u.log.Error(fmt.Sprintf("Ошибка генерации access token: %v", err))
		return nil, err
	}

	oldRefreshToken, exists := resUser.RefreshTokensMap[user.Fingerprint]
	// Если токен уже сущестувет, проверим его срок годности. Если ещё валиден, тогда генерируем только access token
	if exists {
		isExpired, expErr := jwt.IsTokenExpired(oldRefreshToken, true)
		if expErr != nil {
			// Если не вышло декодировать токен, создадим новый токен
			u.log.Error(fmt.Sprintf("ошибка декодирования oldRefreshToken: %v", expErr))
		} else if !isExpired {
			// Если токен не устарел, создаём только access токен
			u.log.Debug("Сгенерирован только новый access token. refresh остаётся старым")
			return &models.UCLoginResponse{
				AccessToken:  accessToken.Token,
				RefreshToken: oldRefreshToken,
				ExpiresIn:    accessToken.ExpiresIn,
			}, nil

		}
	}

	newRefreshToken, err := jwt.GenerateRefreshToken(resUser.ID.String())
	if err != nil {
		u.log.Error(fmt.Sprintf("Ошибка генерации newRefreshToken: %v", err))
		return nil, err
	}

	// Сохраняем или обновляем токены в бд
	resUser.RefreshTokensMap[user.Fingerprint] = newRefreshToken.Token
	u.log.Debug(fmt.Sprintf(`userid = %s`, resUser.ID.String()))
	err = u.repo.UpdateUserRefreshTokens(ctx, resUser.ID, resUser.RefreshTokensMap)
	if err != nil {
		u.log.Error(fmt.Sprintf("ошибка обновления RefreshTokensMap в бд: %v", err))
		return nil, err
	}

	return &models.UCLoginResponse{
		AccessToken:  accessToken.Token,
		RefreshToken: newRefreshToken.Token,
		ExpiresIn:    accessToken.ExpiresIn,
	}, nil
}

func (u *AuthUseсase) Register(ctx context.Context, user models.UCRegisterUserReq) (*models.UCLoginResponse, error) {
	hashedPassword, err := generatePasswordHash(user.Password)
	if err != nil {
		return nil, err
	}

	// Создаём токены
	userID := uuid.New()
	accessToken, errAccess := jwt.GenerateAccessToken(userID.String())
	refreshToken, errRefresh := jwt.GenerateRefreshToken(userID.String())
	if errAccess != nil {
		u.log.Error(fmt.Sprintf("Ошибка генерации access токена: %v", err))
		return nil, err
	} else if errRefresh != nil {
		u.log.Error(fmt.Sprintf("Ошибка генерации refresh токена: %v", err))
		return nil, err
	}

	// Создаём пользователя
	if err = u.repo.CreateUser(ctx, models.RepUserReq{
		UUID:         userID,
		Email:        user.Email,
		PasswordHash: hashedPassword,
		RefreshTokensMap: map[string]string{
			user.Fingerprint: refreshToken.Token,
		},
	}); err != nil {
		u.log.Error(fmt.Sprintf("Ошибка создания пользователя: %v", err))
		return nil, err
	}

	return &models.UCLoginResponse{
		AccessToken:  accessToken.Token,
		RefreshToken: refreshToken.Token,
		ExpiresIn:    accessToken.ExpiresIn,
	}, nil
}

func generatePasswordHash(password string) ([]byte, error) {
	return bcrypt.GenerateFromPassword([]byte(password), bcrypt.MinCost)
}
