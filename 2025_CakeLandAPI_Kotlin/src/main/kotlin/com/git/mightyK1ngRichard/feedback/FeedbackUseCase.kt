package com.git.mightyK1ngRichard.feedback

import com.git.mightyK1ngRichard.feedback.models.AddFeedback

class FeedbackUseCaseImpl(private val repository: FeedbackRepository) : FeedbackUseCase {
    override suspend fun getProductFeedbacks(productID: String) = repository.getProductFeedbacks(productID = productID)
    override suspend fun addFeedback(req: AddFeedback.Request) = repository.addFeedback(req = req)
}
