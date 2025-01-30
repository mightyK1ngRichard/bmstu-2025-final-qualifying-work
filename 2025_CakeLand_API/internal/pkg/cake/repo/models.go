package repo

import (
	"2025_CakeLand_API/internal/models"
	"github.com/google/uuid"
)

type GetCakesListReq struct {
	CakeID uuid.UUID
}

type GetCakesListRes struct {
	Cake models.Cake
}
