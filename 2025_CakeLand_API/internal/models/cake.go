package models

import (
	"github.com/google/uuid"
)

// Cake Модель торта
type Cake struct {
	ID            uuid.UUID  // Код
	Name          string     // Название
	ImageURL      string     // Картинка
	KgPrice       float64    // Цена за кг
	Rating        int        // Рейтинг (от 0 до 5)
	Description   string     // Описаное
	Mass          float64    // Масса торта
	IsOpenForSale bool       // Флаг возможности продажи торта
	Owner         User       // Владелец
	Fillings      []Filling  // Слои торта
	Categories    []Category // Категории торта
}
