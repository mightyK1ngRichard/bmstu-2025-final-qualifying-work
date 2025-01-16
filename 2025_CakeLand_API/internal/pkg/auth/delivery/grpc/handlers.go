package grpcAuth

import (
	"2025_CakeLand_API/internal/models"
	"2025_CakeLand_API/internal/pkg/auth"
	generatedAuth "2025_CakeLand_API/internal/pkg/auth/delivery/grpc/generated"
	"context"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type AuthGrpcHandler struct {
	usecase auth.IAuthUsecase
	generatedAuth.UnimplementedAuthServer
}

func NewGrpcAuthHandler(usecase auth.IAuthUsecase) *AuthGrpcHandler {
	return &AuthGrpcHandler{
		usecase: usecase,
	}
}

func (h *AuthGrpcHandler) Register(ctx context.Context, req *generatedAuth.RegisterRequest) (*generatedAuth.RegisterResponse, error) {
	registerUser := models.UCRegisterUserReq{
		Email:    req.Email,
		Password: req.Password,
	}
	res, err := h.usecase.Register(ctx, registerUser)
	if err != nil {
		return nil, err
	}

	return &generatedAuth.RegisterResponse{
		UserUID: res.UserUID.String(),
	}, nil
}

func (h *AuthGrpcHandler) Login(ctx context.Context, req *generatedAuth.LoginRequest) (*generatedAuth.LoginResponse, error) {
	if req.Email == "" {
		return nil, status.Error(codes.InvalidArgument, "email is required")
	}
	if req.Password == "" {
		return nil, status.Error(codes.InvalidArgument, "password is required")
	}

	loginUser := models.UCLoginUser{
		Email:        req.Email,
		PasswordHash: req.Password,
	}
	token, err := h.usecase.Login(ctx, loginUser)
	if err != nil {
		return nil, err
	}

	return &generatedAuth.LoginResponse{
		Token: token,
	}, nil
}

func (h *AuthGrpcHandler) Logout(context.Context, *generatedAuth.LogoutRequest) (*generatedAuth.LogoutResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method Logout not implemented")
}
