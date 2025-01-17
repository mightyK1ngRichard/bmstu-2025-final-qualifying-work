package postgres

import (
	"2025_CakeLand_API/internal/models"
	"context"
	"database/sql"
	"encoding/json"
	"github.com/google/uuid"
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

func (r *AuthRepository) CreateUser(ctx context.Context, user models.RepUserReq) error {
	refreshTokensJSON, err := json.Marshal(user.RefreshTokensMap)
	if err != nil {
		return err
	}

	if _, err = r.db.ExecContext(ctx,
		createUserCommand,
		user.UUID,
		user.Email,
		user.PasswordHash,
		refreshTokensJSON,
	); err != nil {
		return err
	}

	return nil
}

func (r *AuthRepository) GetUserByEmail(ctx context.Context, email string) (*models.User, error) {
	row := r.db.QueryRowContext(ctx, getUserByEmailCommand, email)
	var user models.User
	var refreshTokensMap []byte
	if err := row.Scan(&user.ID, &user.Email, &user.Nickname, &refreshTokensMap, &user.PasswordHash); err != nil {
		return nil, err
	}
	if err := json.Unmarshal(refreshTokensMap, &user.RefreshTokensMap); err != nil {
		return nil, err
	}
	return &user, nil
}

func (r *AuthRepository) UpdateUserRefreshTokens(ctx context.Context, userID uuid.UUID, refreshTokensMap map[string]string) error {
	refreshTokensJSON, err := json.Marshal(refreshTokensMap)
	if err != nil {
		return err
	}
	_, err = r.db.ExecContext(ctx, updateUserRefreshTokensCommand, refreshTokensJSON, userID)
	return err
}
