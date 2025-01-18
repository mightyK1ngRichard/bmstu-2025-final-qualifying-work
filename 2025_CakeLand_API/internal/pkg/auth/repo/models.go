package repo

import (
	"2025_CakeLand_API/internal/models"
	"github.com/google/uuid"
)

// CreateUser

type CreateUserReq struct {
	UUID             uuid.UUID
	Email            string
	PasswordHash     []byte
	RefreshTokensMap map[string]string
}

// GetUserByEmail

type GetUserByEmailReq struct {
	Email string
}
type GetUserByEmailRes struct {
	User models.User
}

// UpdateUserRefreshTokens

type UpdateUserRefreshTokensReq struct {
	UserID           string
	RefreshTokensMap map[string]string
}

// GetUserRefreshTokens

type GetUserRefreshTokensReq struct {
	UserID string
}
type GetUserRefreshTokensRes struct {
	RefreshTokensMap map[string]string
}
