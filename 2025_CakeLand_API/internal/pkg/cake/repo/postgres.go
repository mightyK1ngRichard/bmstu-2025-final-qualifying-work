package repo

import (
	"2025_CakeLand_API/internal/models"
	en "2025_CakeLand_API/internal/pkg/cake/entities"
	"context"
	"database/sql"
	"github.com/google/uuid"
)

const (
	getCakeByID = `
        SELECT c.id, c.name, c.image_url, c.kg_price, c.rating, c.description, c.mass, c.is_open_for_sale,
               u.id AS owner_id, u.fio, u.nickname, u.mail,
               f.id AS filling_id, f.name AS filling_name, f.image_url AS filling_image,
               f.content AS filling_content, f.kg_price AS filling_price_per_kg, f.description AS filling_description,
               cat.id AS category_id, cat.name AS category_name, cat.image_url AS category_image
        FROM "cake" c
                 LEFT JOIN "user" u ON c.owner_id = u.id
                 LEFT JOIN "cake_filling" cf ON c.id = cf.cake_id
                 LEFT JOIN "filling" f ON cf.filling_id = f.id
                 LEFT JOIN "cake_category" cc ON c.id = cc.cake_id
                 LEFT JOIN "category" cat ON cc.category_id = cat.id
        WHERE c.id = $1;
    `
	createFilling = `
		INSERT INTO "filling" (id, name, image_url, content, kg_price, description)
		VALUES ($1, $2, $3, $4, $5, $6);
	`
	createCategory = `
		INSERT INTO "category" (id, name, image_url)
		VALUES ($1, $2, $3);
	`
	createCake = `
		INSERT INTO "cake" (id, name, image_url, kg_price, rating, description, mass, is_open_for_sale, owner_id)
		VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
	`
	addCateCategory = `
		INSERT INTO "cake_category" (id, category_id, cake_id)
		VALUES (?, ?, ?);
    `
	addFillingCategory = `
		INSERT INTO "cake_filling" (id, cake_id, filling_id)
		VALUES (?, ?, ?);
    `
	categories = `SELECT id, name, image_url FROM "category";`
	fillings   = `SELECT id, name, image_url, content, kg_price, description FROM "filling";`
)

type CakeRepository struct {
	db *sql.DB
}

func NewCakeRepository(db *sql.DB) *CakeRepository {
	return &CakeRepository{
		db: db,
	}
}

func (r *CakeRepository) GetCakeByID(ctx context.Context, in en.GetCakeReq) (*en.GetCakeRes, error) {
	rows, err := r.db.QueryContext(ctx, getCakeByID, in.CakeID)
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
			&cake.ID, &cake.Name, &cake.ImageURL, &cake.KgPrice, &cake.Rating, &cake.Description, &cake.Mass,
			&cake.IsOpenForSale, &owner.ID, &owner.FIO, &owner.Nickname, &owner.Mail,
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

	return &en.GetCakeRes{
		Cake: cake,
	}, nil
}

func (r *CakeRepository) CreateCake(ctx context.Context, in en.CreateCakeDBReq) error {
	tx, err := r.db.BeginTx(ctx, nil)
	if err != nil {
		return err
	}

	// Создаём торт
	_, err = tx.ExecContext(ctx, createCake,
		in.ID, in.Name, in.ImageURL, in.KgPrice, in.Rating,
		in.Description, in.Mass, in.IsOpenForSale, in.OwnerID,
	)
	if err != nil {
		tx.Rollback()
		return err
	}

	// Добавляем категории к торту
	for _, categoryID := range in.CategoryIDs {
		_, err = tx.ExecContext(ctx, addCateCategory,
			uuid.New(), categoryID, in.ID,
		)
		if err != nil {
			tx.Rollback()
			return err
		}
	}

	// Добавляем начинки к торту
	for _, fillingID := range in.FillingIDs {
		_, err = tx.ExecContext(ctx, addFillingCategory,
			uuid.New(), in.ID, fillingID,
		)
		if err != nil {
			tx.Rollback()
			return err
		}
	}

	// Фиксируем транзакцию
	if err := tx.Commit(); err != nil {
		tx.Rollback()
		return err
	}

	return nil
}

func (r *CakeRepository) CreateFilling(ctx context.Context, in models.Filling) error {
	_, err := r.db.ExecContext(ctx, createFilling,
		in.ID,
		in.Name,
		in.ImageURL,
		in.Content,
		in.KgPrice,
		in.Description,
	)

	return err
}

func (r *CakeRepository) CreateCategory(ctx context.Context, in *models.Category) error {
	_, err := r.db.ExecContext(ctx, createCategory, in.ID, in.Name, in.ImageURL)
	return err
}

func (r *CakeRepository) Categories(ctx context.Context) (*[]models.Category, error) {
	rows, err := r.db.QueryContext(ctx, categories)
	defer rows.Close()
	if err != nil {
		return nil, err
	}

	// Чтение результатов
	var categories []models.Category
	for rows.Next() {
		var category models.Category
		if err := rows.Scan(&category.ID, &category.Name, &category.ImageURL); err != nil {
			return nil, err
		}
		categories = append(categories, category)
	}

	// Проверка на ошибки после завершения итерации
	if err := rows.Err(); err != nil {
		return nil, err
	}

	return &categories, nil
}

func (r *CakeRepository) Fillings(ctx context.Context) (*[]models.Filling, error) {
	rows, err := r.db.QueryContext(ctx, fillings)
	defer rows.Close()
	if err != nil {
		return nil, err
	}

	// Чтение результатов
	var fillings []models.Filling
	for rows.Next() {
		var filling models.Filling
		if err := rows.Scan(
			&filling.ID, &filling.Name, &filling.ImageURL,
			&filling.Content, &filling.KgPrice, &filling.Description,
		); err != nil {
			return nil, err
		}
		fillings = append(fillings, filling)
	}

	// Проверка на ошибки после завершения итерации
	if err := rows.Err(); err != nil {
		return nil, err
	}

	return &fillings, nil
}
