package models

type LoginUser struct {
	Email        string
	PasswordHash string
}

type RegisterUser struct {
	Email    string
	Password string
}
