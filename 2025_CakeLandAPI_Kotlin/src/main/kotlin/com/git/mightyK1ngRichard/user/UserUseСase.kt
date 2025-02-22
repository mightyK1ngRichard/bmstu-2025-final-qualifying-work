package com.git.mightyK1ngRichard.user

    class UserUseCaseImpl(private val userRepository: UserRepository) : UserUseCase {
        override suspend fun getUsers() = userRepository.getUsers()
    }
