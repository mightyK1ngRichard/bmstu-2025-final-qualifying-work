package com.git.mightyK1ngRichard.user

import com.git.mightyK1ngRichard.user.models.User
import io.ktor.server.application.*

interface UserController {
    suspend fun getAllUsers(call: ApplicationCall)
}

interface UserUseCase {
    suspend fun getUsers(): List<User>
}

interface UserRepository {
    suspend fun getUsers(): List<User>
}