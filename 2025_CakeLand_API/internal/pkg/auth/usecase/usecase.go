package usecase

import (
	"2025_CakeLand_API/internal/models"
	"2025_CakeLand_API/internal/pkg/auth"
	"2025_CakeLand_API/internal/pkg/auth/repo"
	umodels "2025_CakeLand_API/internal/pkg/auth/usecase/models"
	"2025_CakeLand_API/internal/pkg/utils/jwt"
	"context"
	"fmt"
	"github.com/google/uuid"
	"github.com/pkg/errors"
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

func (u *AuthUseсase) Login(ctx context.Context, in umodels.LoginReq) (*umodels.LoginRes, error) {
	// Получаем данные пользователя
	res, err := u.repo.GetUserByEmail(ctx, repo.GetUserByEmailReq{
		Email: in.Email,
	})
	if err != nil {
		u.log.Error("[Usecase.Login] ошибка получения пользователя по email",
			slog.String("email", in.Email),
			slog.Any("error", err),
		)
		return nil, errors.Wrap(err, "ошибка получения пользователя в Login")
	}

	// Проверяем пароль пользователя
	if !checkPassword(in.Password, res.User.PasswordHash) {
		return nil, models.ErrInvalidPassword
	}

	// Создаём новый access токен
	accessToken, err := jwt.GenerateAccessToken(res.User.ID.String())
	if err != nil {
		u.log.Error("[Usecase.Login] Ошибка генерации access токена", slog.Any("error", err))
		return nil, err
	}

	oldRefreshToken, exists := res.User.RefreshTokensMap[in.Fingerprint]
	// Если токен уже сущестувет, проверим его срок годности. Если ещё валиден, тогда генерируем только access token
	if exists {
		isExpired, expErr := jwt.IsTokenExpired(oldRefreshToken, true)
		if expErr != nil {
			// Если не вышло декодировать токен, создадим новый токен
			u.log.Error("[Usecase.Login] ошибка декодирования oldRefreshToken", slog.Any("error", expErr))
		} else if !isExpired {
			// Если токен не устарел, создаём только access токен
			u.log.Debug("[Usecase.Login] сгенерирован только новый access token. refresh остаётся старым")
			return &umodels.LoginRes{
				AccessToken:  accessToken.Token,
				RefreshToken: oldRefreshToken,
				ExpiresIn:    accessToken.ExpiresIn,
			}, nil
		}
	}

	// Создаём новый рефреш токен
	newRefreshToken, err := jwt.GenerateRefreshToken(res.User.ID.String())
	if err != nil {
		u.log.Error(`[Usecase.Login] ошибка генерации newRefreshToken`, slog.Any("error", err))
		return nil, errors.Wrap(err, "ошибка генерации refresh токена")
	}

	// Сохраняем или обновляем токены в бд
	res.User.RefreshTokensMap[in.Fingerprint] = newRefreshToken.Token
	err = u.repo.UpdateUserRefreshTokens(ctx, repo.UpdateUserRefreshTokensReq{
		UserID:           res.User.ID,
		RefreshTokensMap: res.User.RefreshTokensMap,
	})
	if err != nil {
		u.log.Error(`[Usecase.Login] ошибка обновления RefreshTokensMap в бд`, slog.Any("error", err))
		return nil, errors.Wrap(err, "ошибка перезаписи рефреш токена в базе данных")
	}

	return &umodels.LoginRes{
		AccessToken:  accessToken.Token,
		RefreshToken: newRefreshToken.Token,
		ExpiresIn:    accessToken.ExpiresIn,
	}, nil
}

func (u *AuthUseсase) Register(ctx context.Context, in umodels.RegisterReq) (*umodels.RegisterRes, error) {
	hashedPassword, err := generatePasswordHash(in.Password)
	if err != nil {
		u.log.Error(`[Usecase.Register] ошибка хэширования пароля`, slog.Any("error", err))
		return nil, err
	}

	// Создаём токены
	userID := uuid.New()
	accessToken, errAccess := jwt.GenerateAccessToken(userID.String())
	refreshToken, errRefresh := jwt.GenerateRefreshToken(userID.String())
	if errAccess != nil {
		u.log.Error(`[Usecase.Register] ошибка генерации access токена`, slog.Any("error", errAccess))
		return nil, errAccess
	} else if errRefresh != nil {
		u.log.Error(`[Usecase.Register] ошибка генерации refresh токена`, slog.Any("error", errRefresh))
		return nil, errRefresh
	}

	// Создаём пользователя
	if err = u.repo.CreateUser(ctx, repo.CreateUserReq{
		UUID:         userID,
		Email:        in.Email,
		PasswordHash: hashedPassword,
		RefreshTokensMap: map[string]string{
			in.Fingerprint: refreshToken.Token,
		},
	}); err != nil {
		u.log.Error(`[Usecase.Register] ошибка создания пользователя`, slog.String("error", fmt.Sprintf("%v", err)))
		return nil, err
	}

	return &umodels.RegisterRes{
		AccessToken:  accessToken.Token,
		RefreshToken: refreshToken.Token,
		ExpiresIn:    accessToken.ExpiresIn,
	}, nil
}

func (u *AuthUseсase) UpdateAccessToken(ctx context.Context, in umodels.UpdateAccessTokenReq) {
}

func generatePasswordHash(password string) ([]byte, error) {
	return bcrypt.GenerateFromPassword([]byte(password), bcrypt.MinCost)
}

func checkPassword(inputPassword string, realPassword []byte) bool {
	err := bcrypt.CompareHashAndPassword(realPassword, []byte(inputPassword))
	return err == nil
}
