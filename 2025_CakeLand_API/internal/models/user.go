package models

import (
	"github.com/google/uuid"
	"github.com/guregu/null"
)

type User struct {
	ID               uuid.UUID
	FIO              null.String
	Address          null.String
	Nickname         string
	ImageURL         null.String
	Mail             string
	PasswordHash     []byte
	Phone            null.String
	CardNumber       null.String
	RefreshTokensMap map[string]string // key: fingerprint, value: refreshToken
}
