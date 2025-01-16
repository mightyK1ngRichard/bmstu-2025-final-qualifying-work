CREATE TABLE "user"
(
    userID           uuid PRIMARY KEY,
    email            VARCHAR(100) UNIQUE NOT NULL,
    name             VARCHAR(100),
    refreshTokensMap JSONB,
    passwordHash     varchar(100)        NOT NULL
);