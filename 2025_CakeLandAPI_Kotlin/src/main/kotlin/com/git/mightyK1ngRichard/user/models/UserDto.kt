package com.git.mightyK1ngRichard.user.models

import kotlinx.serialization.Serializable

@Serializable
data class UserDto(
    val id: String,
    val fio: String?,
    val mail: String?
)
