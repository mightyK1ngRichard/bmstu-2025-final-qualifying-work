package models

import (
	"errors"
	"fmt"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

var (
	ErrUserNotFound        = errors.New("пользователь не найден")
	ErrNotFound            = errors.New("NotFound")
	InternalError          = errors.New("InternalError")
	NoToken                = errors.New("NoToken")
	NoMetadata             = errors.New("missing metadata")
	MissingFingerprint     = errors.New("missing fingerprint")
	ErrInvalidPassword     = errors.New("неверный пароль")
	ErrInvalidRefreshToken = errors.New("неверный refresh токен")
	ErrUserAlreadyExists   = errors.New("пользователь с таким email уже существует")
)

/* ################ DataBaseError ################ */

// DataBaseError ошибки для работы с базой данных.
type DataBaseError struct {
	Method string // Описание места ошибки
	Err    error  // Оригинальная ошибка
}

// NewDataBaseError Новый конструктор для DataBaseError
func NewDataBaseError(method string, err error) *DataBaseError {
	return &DataBaseError{
		Method: method,
		Err:    err,
	}
}

// Error Реализация интерфейса error
func (e *DataBaseError) Error() string {
	return fmt.Sprintf("Database error occurred in method %s with: %v", e.Method, e.Err)
}

// Unwrap Можем добавить дополнительный метод для извлечения оригинальной ошибки
func (e *DataBaseError) Unwrap() error {
	return e.Err
}

/* ################ ImageStorageError ################ */

// ImageStorageError - ошибка, возникающая при работе с хранилищем изображений.
type ImageStorageError struct {
	Message string
	Err     error
}

// Error implements the error interface for ImageStorageError.
func (e *ImageStorageError) Error() string {
	if e.Err != nil {
		return fmt.Sprintf("ImageStorageError: %s: %v", e.Message, e.Err)
	}
	return fmt.Sprintf("ImageStorageError: %s", e.Message)
}

// NewImageStorageError создает новую ошибку ImageStorageError.
func NewImageStorageError(message string, err error) *ImageStorageError {
	return &ImageStorageError{
		Message: message,
		Err:     err,
	}
}

// HandleError обрабатывает ошибку и возвращает соответствующую gRPC ошибку с нужным кодом и сообщением.
func HandleError(err error) error {
	if err != nil {
		// Обработка ошибки базы данных
		var dbErr *DataBaseError
		if errors.As(err, &dbErr) {
			return status.Errorf(codes.Internal, "Database error: %v", dbErr.Error())
		}

		// Обработка ошибки хранилища изображений
		var imgErr *ImageStorageError
		if errors.As(err, &imgErr) {
			return status.Errorf(codes.Internal, "Image storage error: %v", imgErr.Error())
		}

		// Проверка на стандартные ошибки
		switch {
		case errors.Is(err, ErrUserNotFound):
			return status.Errorf(codes.NotFound, "Пользователь не найден: %v", err)
		case errors.Is(err, ErrNotFound):
			return status.Errorf(codes.NotFound, "Не найдено: %v", err)
		case errors.Is(err, ErrInvalidPassword):
			return status.Errorf(codes.Unauthenticated, "Неверный пароль: %v", err)
		case errors.Is(err, ErrInvalidRefreshToken):
			return status.Errorf(codes.Unauthenticated, "Неверный refresh токен: %v", err)
		case errors.Is(err, ErrUserAlreadyExists):
			return status.Errorf(codes.AlreadyExists, "Пользователь с таким email уже существует: %v", err)
		case errors.Is(err, NoToken):
			return status.Errorf(codes.Unauthenticated, "Отсутствует токен: %v", err)
		case errors.Is(err, NoMetadata):
			return status.Errorf(codes.InvalidArgument, "Отсутствуют метаданные: %v", err)
		case errors.Is(err, MissingFingerprint):
			return status.Errorf(codes.InvalidArgument, "Отсутствует отпечаток пальца: %v", err)
		default:
			return status.Errorf(codes.Unknown, "Неизвестная ошибка: %v", err.Error())
		}
	}

	return nil
}
