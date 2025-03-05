package com.git.mightyK1ngRichard.transport.feedback.models

import kotlinx.serialization.Serializable

sealed class AddFeedback {
    @Serializable
    data class Request(
        val text: String,
        val rating: Int,
        val cakeUid: String,
    )

    @Serializable
    data class Response(
        val feedbackUid: String
    )

    data class FeedbackContent(
        val text: String,
        val rating: Int,
        val cakeUid: String,
        val authorUid: String,
        val expiresIn: Long,
    )
}

fun AddFeedback.Request.toFeedbackContent(authorUid: String, expiresIn: Long) = AddFeedback.FeedbackContent(
    text = text,
    rating = rating,
    cakeUid = cakeUid,
    authorUid = authorUid,
    expiresIn = expiresIn,
)