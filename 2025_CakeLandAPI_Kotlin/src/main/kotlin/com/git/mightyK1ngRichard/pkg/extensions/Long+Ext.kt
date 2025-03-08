package com.git.mightyK1ngRichard.pkg.extensions

import java.time.Instant

// Проверяем, истек ли токен
fun Long.isExpired(): Boolean {
    val expirationTime = Instant.ofEpochSecond(this)
    val currentTime = Instant.now()

    return expirationTime.isBefore(currentTime)
}
