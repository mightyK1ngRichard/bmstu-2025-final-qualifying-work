package models

import "github.com/google/uuid"

// Category Модель категории
type Category struct {
	ID       uuid.UUID // Код
	Name     string    // Название
	ImageURL string    // Картинка
}
