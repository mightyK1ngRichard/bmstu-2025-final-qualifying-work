package models

import "time"

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

// UpdateAccessToken

type UpdateAccessTokenReq struct {
	RefreshToken string
	Fingerprint  string
}
type UpdateAccessTokenRes struct {
	AccessToken string
	ExpiresIn   time.Time
}

// Logout

type LogoutReq struct {
	RefreshToken string
	Fingerprint  string
}
type LogoutRes struct {
	Message string
}
