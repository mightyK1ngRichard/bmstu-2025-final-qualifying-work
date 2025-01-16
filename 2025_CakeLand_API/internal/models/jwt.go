package models

import "time"

type RefreshTokenPayload struct {
	UserID    uint
	Token     string
	ExpiresAt time.Time
}
