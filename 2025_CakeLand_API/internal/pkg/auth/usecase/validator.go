package usecase

import (
	"github.com/pkg/errors"
	"regexp"
)

var (
	passwordRegexp = regexp.MustCompile(`^[a-zA-Z0-9]{8,}$`)
	emailRegexp    = regexp.MustCompile(`^[a-z0-9]+@[a-z0-9]+\.[a-z]{2,4}$`)
	nameRegexp     = regexp.MustCompile(`^[a-zA-Zа-яА-ЯёЁ\s-]+$`)
)

type Validator struct{}

func NewValidator() *Validator {
	return &Validator{}
}

// validateEmail Функция валидации почты
func (v *Validator) validateEmail(email string) error {
	if !emailRegexp.MatchString(email) {
		return errors.New("invalid email format")
	}
	return nil
}

// validatePassword Функция для проверки валидности пароля
func (v *Validator) validatePassword(password string) error {
	if len(password) < 8 {
		return errors.New("password must be at least 8 characters")
	}
	if !passwordRegexp.MatchString(password) {
		return errors.New("password must contain at least one letter and one number")
	}
	return nil
}

// validateName Функция валидации имени пользователя
func (v *Validator) validateName(name string) error {
	if len(name) < 2 || len(name) > 50 {
		return errors.New("name must be between 2 and 50 characters long")
	}

	if !nameRegexp.MatchString(name) {
		return errors.New("name can only contain letters, spaces, and '-'")
	}

	return nil
}
