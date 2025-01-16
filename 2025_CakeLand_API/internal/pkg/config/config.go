package config

import (
	"flag"
	"fmt"
	"github.com/ilyakaznacheev/cleanenv"
	"os"
	"time"
)

type Config struct {
	Env  string         `yaml:"env" env-default:"local"`
	GRPC GRPCConfig     `yaml:"grpc"`
	DB   DatabaseConfig `yaml:"database"`
}

type GRPCConfig struct {
	Port    int           `yaml:"port"`
	Timeout time.Duration `yaml:"timeout"`
}

type DatabaseConfig struct {
	Host     string `yaml:"host"`
	DBName   string `yaml:"dbName"`
	Port     int    `yaml:"port"`
	User     string `yaml:"user"`
	Password string `yaml:"password"`
	SSLMode  string `yaml:"sslmode"`
}

func NewConfig() (*Config, error) {
	configPath := fetchConfigPath()
	if configPath == "" {
		return nil, fmt.Errorf("путь к конфигурационному файлу пустой")
	}
	if _, err := os.Stat(configPath); os.IsNotExist(err) {
		return nil, fmt.Errorf("файл конфигурации не существует: %s", configPath)
	}
	var cfg Config
	if err := cleanenv.ReadConfig(configPath, &cfg); err != nil {
		return nil, fmt.Errorf("ошибка чтения файла конфигурации: %s", err.Error())
	}
	return &cfg, nil
}

// fetchConfigPath fetches config path from command line flag or environment variable.
// Priority: flag > env > default.
// Default value is empty string.
func fetchConfigPath() string {
	var res string
	flag.StringVar(&res, "config", "", "путь к конфигурационному файлу")
	flag.Parse()
	if res == "" {
		res = os.Getenv("CONFIG_PATH")
	}
	return res
}
