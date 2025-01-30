package postgres

import (
	"2025_CakeLand_API/internal/models"
	"2025_CakeLand_API/internal/pkg/cake/repo"
	"context"
	"database/sql"
	"github.com/google/uuid"
)

type CakeRepository struct {
	db *sql.DB
}

func NewCakeRepository(db *sql.DB) *CakeRepository {
	return &CakeRepository{
		db: db,
	}
}

func (r *CakeRepository) GetCakeByID(ctx context.Context, in repo.GetCakesListReq) (*repo.GetCakesListRes, error) {
	query := `
        SELECT c.id, c.name, c.image_url, c.kg_price, c.rating, c.description, c.mass, c.is_open_for_sale,
               u.id AS owner_id, u.fio, u.nickname, u.mail,
               f.id AS filling_id, f.name AS filling_name, f.image_url AS filling_image,
               f.content AS filling_content, f.kg_price AS filling_price_per_kg, f.description AS filling_description,
               cat.id AS category_id, cat.name AS category_name, cat.image_url AS category_image
        FROM "cake" c
                 LEFT JOIN "user" u ON c.owner_id = u.id
                 LEFT JOIN "cake_filling" cf ON c.id = cf.cake_id
                 LEFT JOIN "filling" f ON cf.filling_id = f.id
                 LEFT JOIN "cake_category" cc ON c.id = cc.id
                 LEFT JOIN "category" cat ON cc.category_id = cat.id
        WHERE c.id = $1;
    `

	rows, err := r.db.Query(query, in.CakeID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var cake models.Cake
	cake.Fillings = []models.Filling{}
	cake.Categories = []models.Category{}
	// Map for unique fillings and categories to avoid duplicates
	fillingMap := make(map[uuid.UUID]bool)
	categoryMap := make(map[uuid.UUID]bool)

	for rows.Next() {
		var filling models.Filling
		var category models.Category
		var owner models.User

		// Read data
		err := rows.Scan(
			&cake.ID, &cake.Name, &cake.ImageURL, &cake.KgPrice, &cake.Rating, &cake.Description, &cake.Mass, &cake.IsOpenForSale,
			&owner.ID, &owner.FIO, &owner.Nickname, &owner.Mail,
			&filling.ID, &filling.Name, &filling.ImageURL, &filling.Content, &filling.KgPrice, &filling.Description,
			&category.ID, &category.Name, &category.ImageURL,
		)
		if err != nil {
			return nil, err
		}

		// Set owner (only once, since it's the same for all rows)
		if cake.Owner.ID == uuid.Nil {
			cake.Owner = owner
		}

		// Add unique fillings
		if filling.ID != uuid.Nil && !fillingMap[filling.ID] {
			fillingMap[filling.ID] = true
			cake.Fillings = append(cake.Fillings, filling)
		}

		// Add unique categories
		if category.ID != uuid.Nil && !categoryMap[category.ID] {
			categoryMap[category.ID] = true
			cake.Categories = append(cake.Categories, category)
		}
	}

	if err := rows.Err(); err != nil {
		return nil, err
	}

	return &repo.GetCakesListRes{
		Cake: cake,
	}, nil
}
