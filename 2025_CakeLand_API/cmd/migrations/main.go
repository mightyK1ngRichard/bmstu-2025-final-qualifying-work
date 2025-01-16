package main

import (
	"fmt"
	"log"

	"github.com/golang-migrate/migrate/v4"
	_ "github.com/golang-migrate/migrate/v4/database/postgres"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	_ "github.com/lib/pq"
)

// go run ./cmd/migrations/main.go
func main() {
	dsn := fmt.Sprintf("postgres://%s:%s@%s:%s/%s?sslmode=%s",
		"mightyK1ngRichard",
		"kingPassword",
		"0.0.0.0",
		"5432",
		"CakeLandDatabase",
		"disable",
	)

	// Настройка источника миграций
	migrationsPath := "file://migrations"

	// Инициализация миграций
	m, err := migrate.New(migrationsPath, dsn)
	if err != nil {
		log.Fatalf("Error initializing migrations: %v", err)
	}

	// Применение миграций
	err = m.Up()
	if err != nil && err.Error() != "no change" {
		log.Fatalf("Error applying migrations: %v", err)
	}

	fmt.Println("Migrations applied successfully.")
}
