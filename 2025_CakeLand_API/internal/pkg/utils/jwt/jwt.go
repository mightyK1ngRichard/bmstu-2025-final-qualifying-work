package jwt

import (
	"2025_CakeLand_API/internal/models"
	"fmt"
	"github.com/golang-jwt/jwt/v4"
	"time"
)

var (
	accessSecret  = []byte("access_secret_key")
	refreshSecret = []byte("refresh_secret_key")
)

// GenerateAccessToken генерирует access токен
func GenerateAccessToken(userUID string) (*models.JWTTokenPayload, error) {
	accessExpiryTime := time.Now().Add(15 * time.Minute) // срок действия 15 минут
	accessClaims := jwt.MapClaims{
		"user_id": userUID,
		"exp":     accessExpiryTime.Unix(),
	}
	accessToken := jwt.NewWithClaims(jwt.SigningMethodHS256, accessClaims)
	accessTokenString, err := accessToken.SignedString(accessSecret)
	if err != nil {
		return nil, err
	}

	return &models.JWTTokenPayload{
		UserUID:   userUID,
		Token:     accessTokenString,
		ExpiresIn: accessExpiryTime,
	}, nil
}

// GenerateRefreshToken генерирует refresh токен
func GenerateRefreshToken(userUID string) (*models.JWTTokenPayload, error) {
	refreshExpiryTime := time.Now().Add(7 * 24 * time.Hour) // срок действия 7 дней
	refreshClaims := jwt.MapClaims{
		"user_id": userUID,
		"exp":     refreshExpiryTime.Unix(),
	}
	refreshToken := jwt.NewWithClaims(jwt.SigningMethodHS256, refreshClaims)
	refreshTokenString, err := refreshToken.SignedString(refreshSecret)
	if err != nil {
		return nil, err
	}
	return &models.JWTTokenPayload{
		UserUID:   userUID,
		Token:     refreshTokenString,
		ExpiresIn: refreshExpiryTime,
	}, nil
}

// IsTokenExpired проверяет, истёк ли срок действия токена
func IsTokenExpired(tokenString string, isRefresh bool) (bool, error) {
	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		// Проверка метода подписи
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		if isRefresh {
			return refreshSecret, nil
		} else {
			return accessSecret, nil
		}
	})

	if err != nil {
		return false, err
	}

	// Получение claims
	if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
		// Проверка наличия "exp"
		if exp, ok := claims["exp"].(float64); ok {
			expirationTime := time.Unix(int64(exp), 0)
			// Проверяем, истёк ли токен
			if time.Now().After(expirationTime) {
				return true, nil // Токен истёк
			}
			return false, nil // Токен действителен
		}
		return false, fmt.Errorf("expiration time (exp) not found in token")
	}

	return false, fmt.Errorf("invalid token")
}
