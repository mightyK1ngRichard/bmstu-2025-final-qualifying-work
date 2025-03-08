package models

import (
	"2025_CakeLand_API/internal/models"
	"github.com/google/uuid"
)

type GetCakeReq struct {
	CakeID uuid.UUID
}

type GetCakeRes struct {
	Cake models.Cake
}
