package cake

import (
	"2025_CakeLand_API/internal/models"
	"2025_CakeLand_API/internal/pkg/cake"
	"2025_CakeLand_API/internal/pkg/cake/delivery/grpc/generated"
	umodels "2025_CakeLand_API/internal/pkg/cake/usecase/models"
	"context"
	"fmt"
	"github.com/google/uuid"
	"github.com/pkg/errors"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"log/slog"
)

type GrpcCakeHandler struct {
	generated.UnimplementedCakeServiceServer

	log     *slog.Logger
	usecase cake.ICakeUsecase
}

func NewCakeHandler(logger *slog.Logger, uc cake.ICakeUsecase) *GrpcCakeHandler {
	return &GrpcCakeHandler{
		log:     logger,
		usecase: uc,
	}
}

func (h *GrpcCakeHandler) Cake(ctx context.Context, in *generated.CakeRequest) (*generated.CakeResponse, error) {
	cakeID, err := uuid.Parse(in.CakeID)
	if err != nil {
		h.log.Error("Ошибка парсинга CakeID", "CakeID", in.CakeID, "error", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("Некорректный формат CakeID: %s", in.CakeID))
	}

	res, err := h.usecase.Cake(ctx, umodels.GetCakeReq{
		CakeID: cakeID,
	})
	if err != nil {
		if errors.Is(err, models.NoToken) {
			return nil, status.Error(codes.NotFound, fmt.Sprintf(`%v`, err))
		}
		return nil, err
	}

	// Маппинг User -> generated.User
	owner := &generated.User{
		Id:       res.Cake.Owner.ID.String(),
		Nickname: res.Cake.Owner.Nickname,
		Mail:     res.Cake.Owner.Mail,
		Fio: func() string {
			if res.Cake.Owner.FIO.Valid {
				return res.Cake.Owner.FIO.String
			} else {
				return ""
			}
		}(),
	}

	// Маппинг Filling -> generated.Filling
	fillings := make([]*generated.Filling, len(res.Cake.Fillings))
	for i, f := range res.Cake.Fillings {
		fillings[i] = &generated.Filling{
			Id:          f.ID.String(),
			Name:        f.Name,
			ImageUrl:    f.ImageURL,
			Content:     f.Content,
			KgPrice:     f.KgPrice,
			Description: f.Description,
		}
	}

	// Маппинг Category -> generated.Category
	categories := make([]*generated.Category, len(res.Cake.Categories))
	for i, c := range res.Cake.Categories {
		categories[i] = &generated.Category{
			Id:       c.ID.String(),
			Name:     c.Name,
			ImageUrl: c.ImageURL,
		}
	}

	// Формируем CakeResponse
	return &generated.CakeResponse{
		Cake: &generated.Cake{
			Id:            res.Cake.ID.String(),
			Name:          res.Cake.Name,
			ImageUrl:      res.Cake.ImageURL,
			KgPrice:       res.Cake.KgPrice,
			Rating:        int32(res.Cake.Rating),
			Description:   res.Cake.Description,
			Mass:          res.Cake.Mass,
			IsOpenForSale: res.Cake.IsOpenForSale,
			Owner:         owner,
			Fillings:      fillings,
			Categories:    categories,
		},
	}, nil
}
