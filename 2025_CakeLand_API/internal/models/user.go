package models

import "github.com/google/uuid"

// UCLoginUser is user info for usecase
// where UC - Usecase
type UCLoginUser struct {
	Email        string
	PasswordHash string
}

// UCRegisterUserReq is user info for usecase
// where UC - Usecase
type UCRegisterUserReq struct {
	Email    string
	Password string
}

type UCRegisterUserRes struct {
	UserUID uuid.UUID
}

// RepUser is user info for repository
type RepUser struct {
	Email        string
	PasswordHash []byte
}

type User struct {
	ID       uuid.UUID
	Nickname string
	Email    string
}
