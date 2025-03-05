package com.git.mightyK1ngRichard.pkg.extensions

import com.git.mightyK1ngRichard.models.ErrorResponse
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.response.*


suspend fun ApplicationCall.errorResponse(code: HttpStatusCode, message: String) {
    this.respond(code, ErrorResponse(message = message))
}