package models

import "time"

// UpdateAccessToken

type UpdateAccessTokenReq struct {
	RefreshToken string
	Fingerprint  string
}
type UpdateAccessTokenRes struct {
	AccessToken string
	ExpiresIn   time.Time
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
