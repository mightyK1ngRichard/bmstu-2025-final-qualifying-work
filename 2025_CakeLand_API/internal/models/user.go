package models

import (
	"github.com/google/uuid"
	"github.com/guregu/null"
)

type User struct {
	ID               uuid.UUID         // Код
	FIO              null.String       // ФИО
	Address          null.String       // Адрес
	Nickname         string            // Уникальный севдоним (default: id)
	ImageURL         null.String       // Картинка
	Mail             string            // Почта
	PasswordHash     []byte            // Пароль
	Phone            null.String       // Телефон
	CardNumber       null.String       // Номер кредитной карты
	RefreshTokensMap map[string]string // Рефреш токены (key: fingerprint, value: refreshToken)
}
