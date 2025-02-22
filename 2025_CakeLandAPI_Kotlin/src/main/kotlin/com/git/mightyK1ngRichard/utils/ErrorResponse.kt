package com.git.mightyK1ngRichard.utils

import kotlinx.serialization.Serializable

@Serializable
data class ErrorResponse(
    var message: String
)