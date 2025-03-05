package com.git.mightyK1ngRichard.models

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.response.*


suspend fun ApplicationCall.errorResponse(code: HttpStatusCode, message: String) {
    this.respond(code, ErrorResponse(message = message))
}