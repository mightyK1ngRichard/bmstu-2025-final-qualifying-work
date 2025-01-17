package repo

import (
	"2025_CakeLand_API/internal/models"
	"github.com/google/uuid"
)

type CreateUserReq struct {
	UUID             uuid.UUID
	Email            string
	PasswordHash     []byte
	RefreshTokensMap map[string]string
}

type GetUserByEmailReq struct {
	Email string
}
type GetUserByEmailRes struct {
	User models.User
}

type UpdateUserRefreshTokensReq struct {
	UserID           uuid.UUID
	RefreshTokensMap map[string]string
}
