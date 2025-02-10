package repo

import (
	"2025_CakeLand_API/internal/models"
	"github.com/google/uuid"
)

// GetCakeByID

type GetCakeReq struct {
	CakeID uuid.UUID
}

type GetCakesRes struct {
	Cake models.Cake
}
