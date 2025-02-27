package com.git.mightyK1ngRichard.feedback

import com.git.mightyK1ngRichard.feedback.models.AddFeedback
import com.git.mightyK1ngRichard.feedback.models.toFeedbackDTO
import com.git.mightyK1ngRichard.utils.DatabaseException
import com.git.mightyK1ngRichard.utils.ErrorResponse
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import kotlinx.serialization.Serializable

class FeedbackControllerImpl(private val useCase: FeedbackUseCase) : FeedbackController {
    override suspend fun getProductFeedbacks(call: ApplicationCall) {
        @Serializable
        data class FeedbackRequest(val productId: String)

        val request = call.receive<FeedbackRequest>()

        try {
            val data = useCase.getProductFeedbacks(request.productId)
            val dataDTO = data.map { it.toFeedbackDTO() }
            call.respond(dataDTO)
        } catch (e: DatabaseException) {
            val errorMessage = "Database error: ${e.message}"
            call.respond(
                HttpStatusCode.InternalServerError,
                ErrorResponse(message = errorMessage)
            )
        } catch (e: Exception) {
            val errorMessage = "Unexpected error: ${e.message}"
            call.respond(
                HttpStatusCode.InternalServerError,
                ErrorResponse(message = errorMessage)
            )
        }
    }

    override suspend fun addFeedback(call: ApplicationCall) {
        val request = call.receive<AddFeedback.Request>()

        try {
            val feedbackUUID = useCase.addFeedback(request)
            call.respond(feedbackUUID)
        } catch (e: DatabaseException) {
            val errorMessage = "Database error: ${e.message}"
            call.respond(
                HttpStatusCode.InternalServerError,
                ErrorResponse(message = errorMessage)
            )
        } catch (e: Exception) {
            val errorMessage = "Unexpected error: ${e.message}"
            call.respond(
                HttpStatusCode.InternalServerError,
                ErrorResponse(message = errorMessage)
            )
        }
    }
}
