package jwt

import (
	"github.com/golang-jwt/jwt/v4"
	"time"
)

var (
	accessSecret  = []byte("access_secret_key")
	refreshSecret = []byte("refresh_secret_key")
)

// GenerateToken генерирует access и refresh токены.
func GenerateToken(userID string) (string, string, error) {
	// Access Token
	accessClaims := jwt.MapClaims{
		"user_id": userID,
		"exp":     time.Now().Add(15 * time.Minute).Unix(), // срок действия 15 минут
	}
	accessToken := jwt.NewWithClaims(jwt.SigningMethodHS256, accessClaims)
	accessTokenString, err := accessToken.SignedString(accessSecret)
	if err != nil {
		return "", "", err
	}

	// Refresh Token
	refreshClaims := jwt.MapClaims{
		"user_id": userID,
		"exp":     time.Now().Add(7 * 24 * time.Hour).Unix(), // срок действия 7 дней
	}
	refreshToken := jwt.NewWithClaims(jwt.SigningMethodHS256, refreshClaims)
	refreshTokenString, err := refreshToken.SignedString(refreshSecret)
	if err != nil {
		return "", "", err
	}

	return accessTokenString, refreshTokenString, nil
}
