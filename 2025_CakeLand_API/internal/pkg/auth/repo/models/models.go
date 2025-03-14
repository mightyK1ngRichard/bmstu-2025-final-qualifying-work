package models

import (
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
	ID               uuid.UUID
	Email            string
	PasswordHash     []byte
	RefreshTokensMap map[string]string // key: fingerprint, value: refreshToken
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
