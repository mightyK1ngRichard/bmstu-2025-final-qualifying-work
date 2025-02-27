package models

import "github.com/google/uuid"

// Filling Модель начинки
type Filling struct {
	ID          uuid.UUID // Код
	Name        string    // Название
	ImageURL    string    // Картинка
	Content     string    // Содержимое начинки
	KgPrice     float64   // Цена за кг
	Description string    // Описание
}
