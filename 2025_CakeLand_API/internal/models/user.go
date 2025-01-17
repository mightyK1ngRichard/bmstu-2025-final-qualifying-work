package models

import (
	"github.com/google/uuid"
	"github.com/guregu/null"
)

type User struct {
	ID               uuid.UUID
	Nickname         null.String
	Email            string
	PasswordHash     []byte
	RefreshTokensMap map[string]string // key: fingerprint, value: refreshToken
}
