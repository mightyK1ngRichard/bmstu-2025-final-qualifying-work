package utils

import (
	"2025_CakeLand_API/internal/pkg/config"
	"database/sql"
	"fmt"
)

func ConnectPostgres(cfg *config.Config) (*sql.DB, error) {
	dsn := fmt.Sprintf(
		"postgres://%s:%s@%s:%d/%s?sslmode=%s",
		cfg.DB.User, cfg.DB.Password, cfg.DB.Host, cfg.DB.Port, cfg.DB.DBName, cfg.DB.SSLMode,
	)

	db, err := sql.Open("postgres", dsn)
	if err != nil {
		return nil, err
	}
	pingErr := db.Ping()
	return db, pingErr
}
