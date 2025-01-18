package usecase

import (
	"2025_CakeLand_API/internal/models"
	"2025_CakeLand_API/internal/pkg/auth"
	"2025_CakeLand_API/internal/pkg/auth/repo"
	umodels "2025_CakeLand_API/internal/pkg/auth/usecase/models"
	"2025_CakeLand_API/internal/pkg/utils/jwt"
	"2025_CakeLand_API/internal/pkg/utils/sl"
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
			sl.Err(err),
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
		u.log.Error("[Usecase.Login] Ошибка генерации access токена", sl.Err(err))
		return nil, err
	}

	oldRefreshToken, exists := res.User.RefreshTokensMap[in.Fingerprint]
	// Если токен уже сущестувет, проверим его срок годности. Если ещё валиден, тогда генерируем только access token
	if exists {
		isExpired, expErr := jwt.IsTokenExpired(oldRefreshToken, true)
		if expErr != nil {
			// Если не вышло декодировать токен, создадим новый токен
			u.log.Error("[Usecase.Login] ошибка декодирования oldRefreshToken", sl.Err(expErr))
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
		u.log.Error(`[Usecase.Login] ошибка генерации newRefreshToken`, sl.Err(err))
		return nil, errors.Wrap(err, "ошибка генерации refresh токена")
	}

	// Сохраняем или обновляем токены в бд
	res.User.RefreshTokensMap[in.Fingerprint] = newRefreshToken.Token
	err = u.repo.UpdateUserRefreshTokens(ctx, repo.UpdateUserRefreshTokensReq{
		UserID:           res.User.ID.String(),
		RefreshTokensMap: res.User.RefreshTokensMap,
	})
	if err != nil {
		u.log.Error(`[Usecase.Login] ошибка обновления RefreshTokensMap в бд`, sl.Err(err))
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
		u.log.Error(`[Usecase.Register] ошибка хэширования пароля`, sl.Err(err))
		return nil, err
	}

	// Создаём токены
	userID := uuid.New()
	accessToken, errAccess := jwt.GenerateAccessToken(userID.String())
	refreshToken, errRefresh := jwt.GenerateRefreshToken(userID.String())
	if errAccess != nil {
		u.log.Error(`[Usecase.Register] ошибка генерации access токена`, sl.Err(errAccess))
		return nil, errAccess
	} else if errRefresh != nil {
		u.log.Error(`[Usecase.Register] ошибка генерации refresh токена`, sl.Err(errRefresh))
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

func (u *AuthUseсase) UpdateAccessToken(ctx context.Context, in umodels.UpdateAccessTokenReq) (*umodels.UpdateAccessTokenRes, error) {
	// Получаем userID пользателя из refresh токена
	userID, err := jwt.GetUserIDFromRefreshToken(in.RefreshToken)
	if err != nil {
		u.log.Error(`[Usecase.UpdateAccessToken] ошибка получени userID из refreshToken`, slog.String("error", fmt.Sprintf("%v", err)))
		return nil, fmt.Errorf("%w: %v", models.ErrInvalidRefreshToken, err)
	}

	// Получаем все refresh токены пользователя
	res, err := u.repo.GetUserRefreshTokens(ctx, repo.GetUserRefreshTokensReq{
		UserID: userID,
	})
	if err != nil {
		u.log.Error(`[Usecase.UpdateAccessToken] ошибка бд`, sl.Err(err))
		return nil, err
	}

	// Ищем refresh токен для заданного fingerprint
	oldRefreshToken, exists := res.RefreshTokensMap[in.Fingerprint]
	if !exists {
		u.log.Error(`[Usecase.UpdateAccessToken] refresh токен не найден в бд`, sl.Err(err))
		return nil, models.NoToken
	}

	// Проверяем схожи ли токены
	if oldRefreshToken != in.RefreshToken {
		u.log.Error(`[Usecase.UpdateAccessToken] refresh токен не совпадает`)
		return nil, models.ErrInvalidRefreshToken
	}

	// Генерируем новый access токен
	accessToken, err := jwt.GenerateAccessToken(userID)
	if err != nil {
		u.log.Error("[Usecase.UpdateAccessToken] ошибка генерации access токена", sl.Err(err))
		return nil, err
	}

	return &umodels.UpdateAccessTokenRes{
		AccessToken: accessToken.Token,
		ExpiresIn:   accessToken.ExpiresIn,
	}, nil
}

func (u *AuthUseсase) Logout(ctx context.Context, in umodels.LogoutReq) (*umodels.LogoutRes, error) {
	userID, err := jwt.GetUserIDFromRefreshToken(in.RefreshToken)
	if err != nil {
		u.log.Error(`[Usecase.Logout] ошибка декодирования токена`, sl.Err(err))
		return nil, err
	}
	res, err := u.repo.GetUserRefreshTokens(ctx, repo.GetUserRefreshTokensReq{
		UserID: userID,
	})
	if err != nil {
		u.log.Error(`[Usecase.Logout] ошибка получения токенов пользователя`, sl.Err(err))
		return nil, err
	}

	delete(res.RefreshTokensMap, in.Fingerprint)
	err = u.repo.UpdateUserRefreshTokens(ctx, repo.UpdateUserRefreshTokensReq{
		UserID:           userID,
		RefreshTokensMap: res.RefreshTokensMap,
	})
	if err != nil {
		u.log.Error(`[Usecase.Logout] ошибка обноваления RefreshTokensMap в бд`, sl.Err(err))
		return nil, err
	}

	return &umodels.LogoutRes{
		Message: "Logged out successfully",
	}, nil
}

func generatePasswordHash(password string) ([]byte, error) {
	return bcrypt.GenerateFromPassword([]byte(password), bcrypt.MinCost)
}

func checkPassword(inputPassword string, realPassword []byte) bool {
	err := bcrypt.CompareHashAndPassword(realPassword, []byte(inputPassword))
	return err == nil
}
