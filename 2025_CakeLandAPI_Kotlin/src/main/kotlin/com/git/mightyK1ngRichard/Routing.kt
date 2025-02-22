package com.git.mightyK1ngRichard

import com.git.mightyK1ngRichard.user.*
import com.git.mightyK1ngRichard.utils.DatabaseFactory
import io.ktor.server.application.*
import io.ktor.server.routing.*
import java.sql.Connection

fun Application.configureRouting() {
    routing {
        get("/users") {
            val userController = getUserController()
            userController.getAllUsers(call)
        }
    }
}

private fun getUserController(): UserController {
    val userRepository: UserRepository = UserRepositoryImpl()
    val userUseCase: UserUseCase = UserUseCaseImpl(userRepository)
    val userController = UserControllerImpl(userUseCase)
    return userController
}