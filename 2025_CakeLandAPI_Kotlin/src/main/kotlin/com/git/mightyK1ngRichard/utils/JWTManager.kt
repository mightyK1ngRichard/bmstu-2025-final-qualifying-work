package com.git.mightyK1ngRichard.utils

import com.auth0.jwt.JWT
import com.auth0.jwt.interfaces.DecodedJWT
import com.git.mightyK1ngRichard.models.UnauthorizedException
import io.ktor.server.application.*

object JWTManager {
    fun getDecodedJWT(call: ApplicationCall): DecodedJWT {
        val authHeader = call.request.headers["Authorization"]
            ?: throw UnauthorizedException("Authorization header is missing")

        val token = authHeader.removePrefix("Bearer ").trim()

        return try {
            JWT.decode(token)
        } catch (e: Exception) {
            throw UnauthorizedException("Invalid or malformed token")
        }
    }

    fun getClaim(call: ApplicationCall, claim: String): String? {
        return getDecodedJWT(call)?.getClaim(claim)?.asString()
    }
}