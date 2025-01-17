package postgres

import (
	"2025_CakeLand_API/internal/models"
	"2025_CakeLand_API/internal/pkg/auth/repo"
	"context"
	"database/sql"
	"encoding/json"
	"github.com/pkg/errors"
)

const (
	isUserExistsCommand            = `SELECT EXISTS(SELECT 1 FROM "user" WHERE email = $1)`
	createUserCommand              = `INSERT INTO "user" (userID, email, passwordHash, refreshTokensMap) VALUES ($1, $2, $3, $4)`
	getUserByEmailCommand          = `SELECT userID, email, name, refreshTokensMap, passwordHash FROM "user" WHERE email = $1`
	updateUserRefreshTokensCommand = `UPDATE "user" SET refreshTokensMap = $1 WHERE userid = $2`
)

type AuthRepository struct {
	db *sql.DB
}

func NewAuthRepository(db *sql.DB) *AuthRepository {
	return &AuthRepository{
		db: db,
	}
}

func (r *AuthRepository) CreateUser(ctx context.Context, in repo.CreateUserReq) error {
	// Проверка существования пользователя с таким email
	var exists bool
	err := r.db.QueryRowContext(ctx, isUserExistsCommand, in.Email).Scan(&exists)
	if err != nil {
		return errors.Wrap(err, "ошибка при проверке существования пользователя")
	}
	if exists {
		return errors.New("пользователь с таким email уже существует")
	}

	// Сериализация RefreshTokensMap в JSON
	refreshTokensJSON, err := json.Marshal(in.RefreshTokensMap)
	if err != nil {
		return errors.Wrap(err, "ошибка сериализации RefreshTokensMap в JSON при создании пользователя")
	}

	// Выполнение команды создания пользователя
	_, err = r.db.ExecContext(ctx,
		createUserCommand,
		in.UUID,
		in.Email,
		in.PasswordHash,
		refreshTokensJSON,
	)
	if err != nil {
		return errors.Wrap(err, "ошибка выполнения команды создания пользователя в базе данных")
	}

	return nil
}

func (r *AuthRepository) GetUserByEmail(ctx context.Context, in repo.GetUserByEmailReq) (*repo.GetUserByEmailRes, error) {
	row := r.db.QueryRowContext(ctx, getUserByEmailCommand, in.Email)
	var user models.User
	var refreshTokensMap []byte
	if err := row.Scan(&user.ID, &user.Email, &user.Nickname, &refreshTokensMap, &user.PasswordHash); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, models.ErrUserNotFound
		}
		return nil, errors.Wrap(err, "ошибка получения данных пользователя из базы данных")
	}
	if err := json.Unmarshal(refreshTokensMap, &user.RefreshTokensMap); err != nil {
		return nil, errors.Wrapf(err, "ошибка декодирования JSON refreshTokensMap для пользователя с email %s", in.Email)
	}

	return &repo.GetUserByEmailRes{
		User: user,
	}, nil
}

func (r *AuthRepository) UpdateUserRefreshTokens(ctx context.Context, in repo.UpdateUserRefreshTokensReq) error {
	// Сериализация RefreshTokensMap в JSON
	refreshTokensJSON, err := json.Marshal(in.RefreshTokensMap)
	if err != nil {
		return errors.Wrap(err, "ошибка сериализации RefreshTokensMap в JSON при обновлении токенов пользователя")
	}

	// Выполнение команды обновления токенов
	if _, err = r.db.ExecContext(ctx, updateUserRefreshTokensCommand, refreshTokensJSON, in.UserID); err != nil {
		return errors.Wrapf(err, "ошибка выполнения команды обновления токенов пользователя с ID %s", in.UserID)
	}

	return nil
}
