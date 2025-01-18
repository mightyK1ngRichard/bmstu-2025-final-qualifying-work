package jwt

import (
	"2025_CakeLand_API/internal/models"
	"github.com/golang-jwt/jwt/v4"
	"github.com/pkg/errors"
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
		return nil, errors.Wrap(models.InternalError, err.Error())
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
		return nil, errors.Wrap(models.InternalError, err.Error())
	}

	return &models.JWTTokenPayload{
		UserUID:   userUID,
		Token:     refreshTokenString,
		ExpiresIn: refreshExpiryTime,
	}, nil
}

// IsTokenExpired проверяет, истёк ли срок действия токена
func IsTokenExpired(tokenString string, isRefresh bool) (bool, error) {
	var secret []byte
	if isRefresh {
		secret = refreshSecret
	} else {
		secret = accessSecret
	}
	// Извлечение claims и валидация токена
	claims, err := getTokenClaims(tokenString, secret)
	if err != nil {
		return false, err
	}
	if exp, ok := claims["exp"].(float64); ok {
		expirationTime := time.Unix(int64(exp), 0)
		// Проверяем, истёк ли токен
		if time.Now().After(expirationTime) {
			return true, nil // Токен истёк
		}
		return false, nil // Токен действителен
	}

	return false, errors.New("expiration time (exp) not found in token")
}

// GetUserIDFromRefreshToken возваращет user_id если токен ещё протух
func GetUserIDFromRefreshToken(tokenString string) (string, error) {
	// Извлечение claims и валидация токена
	claims, err := getTokenClaims(tokenString, refreshSecret)
	if err != nil {
		return "", errors.Wrap(err, "ошибка получения claims")
	}

	exp, ok := claims["exp"].(float64)
	if !ok {
		return "", errors.New("exp not found in token")
	}
	expirationTime := time.Unix(int64(exp), 0)
	if time.Now().After(expirationTime) {
		return "", errors.New("token expired")
	}

	userID, ok := claims["user_id"].(string)
	if !ok {
		return "", errors.New("user_id not found in token")
	}

	return userID, nil
}

func getTokenClaims(tokenString string, secret []byte) (jwt.MapClaims, error) {
	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		// Проверка метода подписи
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, errors.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return secret, nil
	})
	if err != nil {
		return nil, errors.Errorf("error parsing token: %v", err)
	}

	// Извлечение claims и валидация токена
	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok || !token.Valid {
		return nil, errors.New("invalid token or claims")
	}

	return claims, nil
}
