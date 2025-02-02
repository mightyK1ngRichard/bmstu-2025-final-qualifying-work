package models

import (
	"2025_CakeLand_API/internal/models"
	"github.com/google/uuid"
)

// Cake

type GetCakeReq struct {
	CakeID uuid.UUID
}

type GetCakeRes struct {
	Cake models.Cake
}
