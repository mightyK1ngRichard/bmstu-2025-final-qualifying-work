package com.git.mightyK1ngRichard.feedback.models

import kotlinx.serialization.Serializable

sealed class AddFeedback {
    @Serializable
    data class Request(
        val text: String,
        val rating: Int,
        val cakeUid: String,
        val authorUid: String
    )

    @Serializable
    data class Response(
        val feedbackUid: String
    )
}
