package handler

import (
	"2025_CakeLand_API/internal/models"
	"2025_CakeLand_API/internal/pkg/auth"
	gen "2025_CakeLand_API/internal/pkg/auth/delivery/grpc/generated"
	umodels "2025_CakeLand_API/internal/pkg/auth/usecase/models"
	"context"
	"fmt"
	"github.com/pkg/errors"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
)

type GrpcAuthHandler struct {
	usecase auth.IAuthUsecase
	gen.UnimplementedAuthServer
}

func NewGrpcAuthHandler(usecase auth.IAuthUsecase) *GrpcAuthHandler {
	return &GrpcAuthHandler{
		usecase: usecase,
	}
}

func (h *GrpcAuthHandler) Register(ctx context.Context, req *gen.RegisterRequest) (*gen.RegisterResponse, error) {
	fingerprint, err := getFingerprintFromMetadata(ctx)
	if err != nil {
		return nil, status.Error(codes.InvalidArgument, "fingerprint отсутствует в метаданных")
	}
	// Проверка входных параметров
	if err := validateEmailAndPassword(req.Email, req.Password); err != nil {
		return nil, err
	}

	registerUser := umodels.RegisterReq{
		Email:       req.Email,
		Password:    req.Password,
		Fingerprint: fingerprint,
	}
	res, err := h.usecase.Register(ctx, registerUser)
	if err != nil {
		if errors.Is(err, models.ErrUserAlreadyExists) {
			return nil, status.Error(codes.AlreadyExists, fmt.Sprintf(`%v`, err))
		}
		return nil, err
	}

	return &gen.RegisterResponse{
		AccessToken:  res.AccessToken,
		RefreshToken: res.RefreshToken,
		ExpiresIn:    res.ExpiresIn.Unix(),
	}, nil
}

func (h *GrpcAuthHandler) Login(ctx context.Context, req *gen.LoginRequest) (*gen.LoginResponse, error) {
	fingerprint, err := getFingerprintFromMetadata(ctx)
	if err != nil {
		return nil, status.Error(codes.InvalidArgument, "fingerprint отсутствует в метаданных")
	}
	// Проверка входных параметров
	if err := validateEmailAndPassword(req.Email, req.Password); err != nil {
		return nil, err
	}

	loginUser := umodels.LoginReq{
		Email:       req.Email,
		Password:    req.Password,
		Fingerprint: fingerprint,
	}
	res, loginErr := h.usecase.Login(ctx, loginUser)
	if loginErr != nil {
		// Преобразование ошибки в формат gRPC
		if errors.Is(loginErr, models.ErrUserNotFound) || errors.Is(loginErr, models.ErrInvalidPassword) {
			return nil, status.Error(codes.NotFound, "неверный логин или пароль")
		}
		return nil, status.Error(codes.Internal, "внутренняя ошибка сервера")
	}

	return &gen.LoginResponse{
		AccessToken:  res.AccessToken,
		RefreshToken: res.RefreshToken,
		ExpiresIn:    res.ExpiresIn.Unix(),
	}, nil
}

func (h *GrpcAuthHandler) Logout(ctx context.Context, req *gen.LogoutRequest) (*gen.LogoutResponse, error) {
	fingerprint, err := getFingerprintFromMetadata(ctx)
	if err != nil {
		return nil, status.Error(codes.InvalidArgument, "fingerprint отсутствует в метаданных")
	}
	if req.RefreshToken == "" {
		return nil, status.Error(codes.InvalidArgument, "refreshToken обязателен")
	}
	res, err := h.usecase.Logout(ctx, umodels.LogoutReq{
		Fingerprint:  fingerprint,
		RefreshToken: req.RefreshToken,
	})
	if err != nil {
		if errors.Is(err, models.NoToken) {
			return nil, status.Error(codes.InvalidArgument, "неверный refresh токен")
		}
		return nil, err
	}

	return &gen.LogoutResponse{
		Message: res.Message,
	}, nil
}

func (h *GrpcAuthHandler) UpdateAccessToken(ctx context.Context, req *gen.UpdateAccessTokenRequest) (*gen.UpdateAccessTokenResponse, error) {
	fingerprint, err := getFingerprintFromMetadata(ctx)
	if err != nil {
		return nil, status.Error(codes.InvalidArgument, "fingerprint отсутствует в метаданных")
	}
	if req.RefreshToken == "" {
		return nil, status.Error(codes.InvalidArgument, "refreshToken обязателен")
	}

	res, err := h.usecase.UpdateAccessToken(ctx, umodels.UpdateAccessTokenReq{
		RefreshToken: req.RefreshToken,
		Fingerprint:  fingerprint,
	})
	if err != nil {
		if errors.Is(err, models.ErrInvalidRefreshToken) {
			return nil, status.Errorf(codes.InvalidArgument, "%v", err)
		}
		return nil, err
	}

	return &gen.UpdateAccessTokenResponse{
		AccessToken: res.AccessToken,
		ExpiresIn:   res.ExpiresIn.Unix(),
	}, nil
}

func getFingerprintFromMetadata(ctx context.Context) (string, error) {
	md, ok := metadata.FromIncomingContext(ctx)
	if !ok {
		return "", models.NoMetadata
	}
	fingerprint := md.Get("fingerprint")
	if len(fingerprint) == 0 {
		return "", models.MissingFingerprint
	}
	return fingerprint[0], nil
}

func validateEmailAndPassword(email string, password string) error {
	if email == "" {
		return status.Error(codes.InvalidArgument, "email обязателен")
	} else if password == "" {
		return status.Error(codes.InvalidArgument, "password обязателен")
	}
	return nil
}
