package com.git.mightyK1ngRichard.transport.feedback

import com.git.mightyK1ngRichard.pkg.extensions.isExpired
import com.git.mightyK1ngRichard.transport.feedback.models.AddFeedback
import com.git.mightyK1ngRichard.models.UnauthorizedException
import java.time.Instant

class FeedbackUseCaseImpl(private val repository: FeedbackRepository) : FeedbackUseCase {
    override suspend fun getProductFeedbacks(productID: String) = repository.getProductFeedbacks(productID = productID)

    override suspend fun addFeedback(req: AddFeedback.FeedbackContent): AddFeedback.Response {
        if (req.expiresIn.isExpired()) {
            throw UnauthorizedException("Access token is expired")
        }

        return repository.addFeedback(req = req)
    }
}
