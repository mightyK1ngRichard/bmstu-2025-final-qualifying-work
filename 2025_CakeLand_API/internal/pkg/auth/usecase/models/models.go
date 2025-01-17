package models

import "time"

// UpdateAccessToken

type UpdateAccessTokenReq struct {
	UserID       string
	RefreshToken string
}

// Login

type LoginReq struct {
	Email       string
	Password    string
	Fingerprint string
}
type LoginRes struct {
	AccessToken  string
	RefreshToken string
	ExpiresIn    time.Time
}

// Register

type RegisterReq struct {
	Email       string
	Password    string
	Fingerprint string
}
type RegisterRes struct {
	AccessToken  string
	RefreshToken string
	ExpiresIn    time.Time
}
