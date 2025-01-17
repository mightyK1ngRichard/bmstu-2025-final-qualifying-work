package models

import (
	"github.com/google/uuid"
	"github.com/guregu/null"
	"time"
)

// UCLoginUser is user info for usecase
// where UC - Usecase
type UCLoginUser struct {
	Email        string
	PasswordHash string
	Fingerprint  string
}
type UCLoginResponse struct {
	AccessToken  string
	RefreshToken string
	ExpiresIn    time.Time
}

// UCRegisterUserReq is user info for usecase
// where UC - Usecase
type UCRegisterUserReq struct {
	Email       string
	Password    string
	Fingerprint string
}

// RepUserReq is user info for repository
type RepUserReq struct {
	UUID             uuid.UUID
	Email            string
	PasswordHash     []byte
	RefreshTokensMap map[string]string
}

type User struct {
	ID               uuid.UUID
	Nickname         null.String
	Email            string
	PasswordHash     []byte
	RefreshTokensMap map[string]string // key: fingerprint, value: refreshToken
}
