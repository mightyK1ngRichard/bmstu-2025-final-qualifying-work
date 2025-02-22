package com.git.mightyK1ngRichard.user.models

data class User(
    val id: String,
    val fio: String?,
    val mail: String?
)

fun User.toUserDTO(): UserDto {
    return UserDto(id = this.id, fio = this.fio, mail = this.mail)
}