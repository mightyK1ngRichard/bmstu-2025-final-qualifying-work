package handler

import (
	"2025_CakeLand_API/internal/models"
	"2025_CakeLand_API/internal/pkg/cake"
	gen "2025_CakeLand_API/internal/pkg/cake/delivery/grpc/generated"
	en "2025_CakeLand_API/internal/pkg/cake/entities"
	"context"
	"fmt"
	"google.golang.org/protobuf/types/known/emptypb"
	"log/slog"

	"github.com/google/uuid"
	"github.com/pkg/errors"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type GrpcCakeHandler struct {
	gen.UnimplementedCakeServiceServer

	log     *slog.Logger
	usecase cake.ICakeUsecase
}

func NewCakeHandler(logger *slog.Logger, uc cake.ICakeUsecase) *GrpcCakeHandler {
	return &GrpcCakeHandler{
		log:     logger,
		usecase: uc,
	}
}

func (h *GrpcCakeHandler) Cake(ctx context.Context, in *gen.CakeRequest) (*gen.CakeResponse, error) {
	cakeID, err := uuid.Parse(in.CakeId)
	if err != nil {
		h.log.Error("Ошибка парсинга CakeID", "CakeID", in.CakeId, "error", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("Некорректный формат CakeID: %s", in.CakeId))
	}

	res, err := h.usecase.Cake(ctx, en.GetCakeReq{
		CakeID: cakeID,
	})
	if err != nil {
		if errors.Is(err, models.NoToken) {
			return nil, status.Error(codes.NotFound, fmt.Sprintf(`%v`, err))
		}
		return nil, err
	}

	// Маппинг User -> generated.User
	owner := res.Cake.Owner.ConvertToUserGRPC()

	// Маппинг Filling -> generated.Filling
	fillings := make([]*gen.Filling, len(res.Cake.Fillings))
	for i, f := range res.Cake.Fillings {
		fillings[i] = f.ConvertToFillingGRPC()
	}

	// Маппинг Category -> generated.Category
	categories := make([]*gen.Category, len(res.Cake.Categories))
	for i, c := range res.Cake.Categories {
		categories[i] = c.ConvertToCategoryGRPC()
	}

	// Формируем CakeResponse
	return &gen.CakeResponse{
		Cake: &gen.Cake{
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

func (h *GrpcCakeHandler) CreateCake(ctx context.Context, in *gen.CreateCakeRequest) (*gen.CreateCakeResponse, error) {
	res, err := h.usecase.CreateCake(ctx, en.CreateCakeReq{
		Name:          in.Name,
		ImageData:     in.ImageData,
		KgPrice:       in.KgPrice,
		Rating:        in.Rating,
		Description:   in.Description,
		Mass:          in.Mass,
		IsOpenForSale: in.IsOpenForSale,
		OwnerID:       in.OwnerId,
		FillingIDs:    in.FillingIds,
		CategoryIDs:   in.CategoryIds,
	})
	if err != nil {
		return nil, err
	}

	return &gen.CreateCakeResponse{
		CakeId: res.CakeID,
	}, nil
}

func (h *GrpcCakeHandler) CreateFilling(ctx context.Context, in *gen.CreateFillingRequest) (*gen.CreateFillingResponse, error) {
	res, err := h.usecase.CreateFilling(ctx, en.CreateFillingReq{
		Name:        in.Name,
		ImageData:   in.ImageData,
		Content:     in.Content,
		KgPrice:     in.KgPrice,
		Description: in.Description,
	})
	if err != nil {
		return nil, err
	}

	return &gen.CreateFillingResponse{
		Filling: res.Filling.ConvertToFillingGRPC(),
	}, nil
}

func (h *GrpcCakeHandler) CreateCategory(ctx context.Context, in *gen.CreateCategoryRequest) (*gen.CreateCategoryResponse, error) {
	res, err := h.usecase.CreateCategory(ctx, &en.CreateCategoryReq{
		Name:      in.Name,
		ImageData: in.ImageData,
	})
	if err != nil {
		return nil, err
	}

	return &gen.CreateCategoryResponse{
		Category: res.Category.ConvertToCategoryGRPC(),
	}, nil
}

func (h *GrpcCakeHandler) Categories(ctx context.Context, _ *emptypb.Empty) (*gen.CategoriesResponse, error) {
	categories, err := h.usecase.Categories(ctx)
	if err != nil {
		return nil, err
	}

	categoriesGRPC := make([]*gen.Category, len(*categories))
	for i, it := range *categories {
		categoriesGRPC[i] = it.ConvertToCategoryGRPC()
	}

	return &gen.CategoriesResponse{
		Categories: categoriesGRPC,
	}, nil
}

func (h *GrpcCakeHandler) Fillings(ctx context.Context, _ *emptypb.Empty) (*gen.FillingsResponse, error) {
	fillings, err := h.usecase.Fillings(ctx)
	if err != nil {
		return nil, err
	}

	fillingsGRPC := make([]*gen.Filling, len(*fillings))
	for i, it := range *fillings {
		fillingsGRPC[i] = it.ConvertToFillingGRPC()
	}

	return &gen.FillingsResponse{
		Fillings: fillingsGRPC,
	}, nil
}
