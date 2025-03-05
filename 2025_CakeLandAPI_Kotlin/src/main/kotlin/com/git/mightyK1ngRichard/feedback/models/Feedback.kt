package com.git.mightyK1ngRichard.feedback.models

import java.time.Instant
import kotlinx.serialization.Serializable

data class Feedback(
    val uid: String,
    val text: String,
    val dateCreation: Instant,
    val rating: Int,
    val author: Author
) {
    data class Author(
        val id: String,
        val fio: String?,
        val imageURL: String?,
    )
}

// MARK: - DTO model

@Serializable
data class FeedbackDTO(
    val uid: String,
    val text: String,
    val dateCreation: String,
    val rating: Int,
    val author: AuthorDTO,
)

@Serializable
data class AuthorDTO(
    val uid: String,
    val fio: String?,
    val imageURL: String?,
)

fun Feedback.Author.toAuthorDTO() = AuthorDTO(uid = id, fio = fio, imageURL = imageURL)

fun Feedback.toFeedbackDTO() = FeedbackDTO(
    uid = uid,
    text = text,
    dateCreation = dateCreation.toString(),
    rating = rating,
    author = author.toAuthorDTO()
)