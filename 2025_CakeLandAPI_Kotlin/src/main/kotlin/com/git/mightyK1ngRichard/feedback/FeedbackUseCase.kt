package com.git.mightyK1ngRichard.feedback

import com.git.mightyK1ngRichard.feedback.models.AddFeedback
import com.git.mightyK1ngRichard.models.UnauthorizedException
import java.time.Instant

class FeedbackUseCaseImpl(private val repository: FeedbackRepository) : FeedbackUseCase {
    override suspend fun getProductFeedbacks(productID: String) = repository.getProductFeedbacks(productID = productID)

    override suspend fun addFeedback(req: AddFeedback.FeedbackContent): AddFeedback.Response {
        val expirationTime = Instant.ofEpochSecond(req.expiresIn)
        val currentTime = Instant.now()
        // Проверяем, истек ли токен
        val isExpired = expirationTime.isBefore(currentTime)
        if (isExpired) {
            throw UnauthorizedException("Access token is expired")
        }

        return repository.addFeedback(req = req)
    }
}
