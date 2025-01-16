package postgres

import (
	"2025_CakeLand_API/internal/models"
	"context"
	"database/sql"
	"github.com/google/uuid"
)

const (
	createUserCommand = `INSERT INTO "user" (userID, email, passwordHash) VALUES ($1, $2, $3) RETURNING userID`
)

type AuthRepository struct {
	db *sql.DB
}

func NewAuthRepository(db *sql.DB) *AuthRepository {
	return &AuthRepository{
		db: db,
	}
}

func (r *AuthRepository) CreateUser(ctx context.Context, user models.RepUser) (uuid.UUID, error) {
	var userID uuid.UUID
	row := r.db.QueryRowContext(ctx,
		createUserCommand,
		uuid.New(),
		user.Email,
		user.PasswordHash,
	)
	if err := row.Scan(&userID); err != nil {
		return uuid.Nil, err
	}
	return userID, nil
}
