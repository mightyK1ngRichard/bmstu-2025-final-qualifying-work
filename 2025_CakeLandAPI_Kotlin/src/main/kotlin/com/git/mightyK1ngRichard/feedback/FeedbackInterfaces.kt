package com.git.mightyK1ngRichard.feedback

import com.git.mightyK1ngRichard.feedback.models.AddFeedback
import com.git.mightyK1ngRichard.feedback.models.Feedback
import io.ktor.server.application.*

interface FeedbackController {
    suspend fun getProductFeedbacks(call: ApplicationCall)
    suspend fun addFeedback(call: ApplicationCall)
}

interface FeedbackUseCase {
    suspend fun getProductFeedbacks(productID: String): List<Feedback>
    suspend fun addFeedback(req: AddFeedback.Request): AddFeedback.Response
}

interface FeedbackRepository {
    suspend fun getProductFeedbacks(productID: String): List<Feedback>
    suspend fun addFeedback(req: AddFeedback.Request): AddFeedback.Response
}
