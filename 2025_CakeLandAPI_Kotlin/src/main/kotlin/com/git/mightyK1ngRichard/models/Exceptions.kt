package com.git.mightyK1ngRichard.models

import io.ktor.http.*
import kotlinx.serialization.Serializable

@Serializable
data class ErrorResponse(val message: String)

class UnauthorizedException(
    message: String,
    val code: HttpStatusCode = HttpStatusCode.Unauthorized
) : Exception(message)

class DatabaseException(
    message: String,
    cause: Throwable? = null
) : Exception(message, cause)