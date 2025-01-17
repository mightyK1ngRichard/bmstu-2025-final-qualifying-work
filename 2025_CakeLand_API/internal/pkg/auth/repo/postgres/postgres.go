package postgres

import (
	"2025_CakeLand_API/internal/models"
	"2025_CakeLand_API/internal/pkg/auth/repo"
	"context"
	"database/sql"
	"encoding/json"
)

const (
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
	refreshTokensJSON, err := json.Marshal(in.RefreshTokensMap)
	if err != nil {
		return err
	}

	if _, err = r.db.ExecContext(ctx,
		createUserCommand,
		in.UUID,
		in.Email,
		in.PasswordHash,
		refreshTokensJSON,
	); err != nil {
		return err
	}

	return nil
}

func (r *AuthRepository) GetUserByEmail(ctx context.Context, in repo.GetUserByEmailReq) (*repo.GetUserByEmailRes, error) {
	row := r.db.QueryRowContext(ctx, getUserByEmailCommand, in.Email)
	var user models.User
	var refreshTokensMap []byte
	if err := row.Scan(&user.ID, &user.Email, &user.Nickname, &refreshTokensMap, &user.PasswordHash); err != nil {
		return nil, err
	}
	if err := json.Unmarshal(refreshTokensMap, &user.RefreshTokensMap); err != nil {
		return nil, err
	}

	return &repo.GetUserByEmailRes{
		User: user,
	}, nil
}

func (r *AuthRepository) UpdateUserRefreshTokens(ctx context.Context, in repo.UpdateUserRefreshTokensReq) error {
	refreshTokensJSON, err := json.Marshal(in.RefreshTokensMap)
	if err != nil {
		return err
	}
	_, err = r.db.ExecContext(ctx, updateUserRefreshTokensCommand, refreshTokensJSON, in.UserID)
	return err
}
