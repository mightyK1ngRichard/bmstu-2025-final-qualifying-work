package com.git.mightyK1ngRichard.feedback

import com.git.mightyK1ngRichard.feedback.models.AddFeedback
import com.git.mightyK1ngRichard.feedback.models.toFeedbackContent
import com.git.mightyK1ngRichard.feedback.models.toFeedbackDTO
import com.git.mightyK1ngRichard.models.*
import com.git.mightyK1ngRichard.utils.JWTManager
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
            callAndLogError(call, "Database error: ${e.message}")
        } catch (e: Exception) {
            callAndLogError(call, "Unexpected error: ${e.message}")
        }
    }

    override suspend fun addFeedback(call: ApplicationCall) {
        val request = call.receive<AddFeedback.Request>()

        try {
            // Достаём данные из jwt
            val decodedJWT = JWTManager.getDecodedJWT(call)
            val userID = decodedJWT.getClaim("user_id").asString()
            val expiresIn = decodedJWT.getClaim("exp").asLong()
            val feedbackUID = useCase.addFeedback(request.toFeedbackContent(authorUid = userID, expiresIn = expiresIn))
            call.respond(feedbackUID)
        } catch (e: DatabaseException) {
            callAndLogError(call, "Database error: ${e.message}")
        } catch (e: UnauthorizedException) {
            callAndLogError(call, "bad request: ${e.message}", e.code)
        } catch (e: Exception) {
            callAndLogError(call, "Unexpected error: ${e.message}")
        }
    }
}

private suspend fun callAndLogError(
    call: ApplicationCall,
    errorMessage: String,
    code: HttpStatusCode = HttpStatusCode.InternalServerError
) {
    call.respond(code, ErrorResponse(message = errorMessage))
}