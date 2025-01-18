package grpcAuth

import (
	"2025_CakeLand_API/internal/models"
	"2025_CakeLand_API/internal/pkg/auth"
	genAuth "2025_CakeLand_API/internal/pkg/auth/delivery/grpc/generated"
	umodels "2025_CakeLand_API/internal/pkg/auth/usecase/models"
	"context"
	"fmt"
	"github.com/pkg/errors"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
)

type AuthGrpcHandler struct {
	usecase auth.IAuthUsecase
	genAuth.UnimplementedAuthServer
}

func NewGrpcAuthHandler(usecase auth.IAuthUsecase) *AuthGrpcHandler {
	return &AuthGrpcHandler{
		usecase: usecase,
	}
}

func (h *AuthGrpcHandler) Register(ctx context.Context, req *genAuth.RegisterRequest) (*genAuth.RegisterResponse, error) {
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

	return &genAuth.RegisterResponse{
		AccessToken:  res.AccessToken,
		RefreshToken: res.RefreshToken,
		ExpiresIn:    res.ExpiresIn.Unix(),
	}, nil
}

func (h *AuthGrpcHandler) Login(ctx context.Context, req *genAuth.LoginRequest) (*genAuth.LoginResponse, error) {
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

	return &genAuth.LoginResponse{
		AccessToken:  res.AccessToken,
		RefreshToken: res.RefreshToken,
		ExpiresIn:    res.ExpiresIn.Unix(),
	}, nil
}

func (h *AuthGrpcHandler) Logout(ctx context.Context, req *genAuth.LogoutRequest) (*genAuth.LogoutResponse, error) {
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
		return nil, err
	}

	return &genAuth.LogoutResponse{
		Message: res.Message,
	}, nil
}

func (h *AuthGrpcHandler) UpdateAccessToken(ctx context.Context, req *genAuth.UpdateAccessTokenRequest) (*genAuth.UpdateAccessTokenResponse, error) {
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

	return &genAuth.UpdateAccessTokenResponse{
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
