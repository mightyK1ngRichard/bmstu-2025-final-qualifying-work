package com.git.mightyK1ngRichard.user

import com.git.mightyK1ngRichard.user.models.toUserDTO
import com.git.mightyK1ngRichard.utils.DatabaseException
import com.git.mightyK1ngRichard.utils.ErrorResponse
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.response.*

class UserControllerImpl(private val useCase: UserUseCase) : UserController {
    override suspend fun getAllUsers(call: ApplicationCall) {
        try {
            val users = useCase.getUsers()
            val usersDTO = users.map { it.toUserDTO() }
            call.respond(usersDTO)
        } catch (e: DatabaseException) {
            val errorMessage = "Database error: ${e.message}"
            call.respond(
                HttpStatusCode.InternalServerError,
                ErrorResponse(message = errorMessage)
            )
        } catch (e: Exception) {
            val errorMessage = "Unexpected error: ${e.message}"
            call.respond(
                HttpStatusCode.InternalServerError,
                ErrorResponse(message = errorMessage)
            )
        }
    }
}
