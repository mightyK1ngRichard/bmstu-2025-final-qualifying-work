package models

import "errors"

var (
	ErrUserNotFound        = errors.New("пользователь не найден")
	NotFound               = errors.New("NotFound")
	InternalError          = errors.New("InternalError")
	NoToken                = errors.New("NoToken")
	NoMetadata             = errors.New("missing metadata")
	MissingFingerprint     = errors.New("missing fingerprint")
	ErrInvalidPassword     = errors.New("неверный пароль")
	ErrInvalidRefreshToken = errors.New("неверный refresh токен")
)
