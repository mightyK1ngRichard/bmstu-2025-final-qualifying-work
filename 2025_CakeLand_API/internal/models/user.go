package models

import (
	"2025_CakeLand_API/internal/pkg/cake/delivery/grpc/generated"
	"github.com/google/uuid"
	"github.com/guregu/null"
)

type User struct {
	ID               uuid.UUID         // Код
	FIO              null.String       // ФИО
	Address          null.String       // Адрес
	Nickname         string            // Уникальный псевдоним (default: id)
	ImageURL         null.String       // Картинка
	Mail             string            // Почта
	PasswordHash     []byte            // Пароль
	Phone            null.String       // Телефон
	CardNumber       null.String       // Номер кредитной карты
	RefreshTokensMap map[string]string // Рефреш токены (key: fingerprint, value: refreshToken)
}

func (u *User) ConvertToUserGRPC() *generated.User {
	return &generated.User{
		Id:       u.ID.String(),
		Nickname: u.Nickname,
		Mail:     u.Mail,
		Fio: func() string {
			if u.FIO.Valid {
				return u.FIO.String
			} else {
				return ""
			}
		}(),
	}
}
