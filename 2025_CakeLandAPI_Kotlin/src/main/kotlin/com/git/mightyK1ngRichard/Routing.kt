package com.git.mightyK1ngRichard

import com.git.mightyK1ngRichard.feedback.*
import io.ktor.server.application.*
import io.ktor.server.routing.*

fun Application.configureRouting() {

    routing {
        route("/feedbacks") {
            val controller = getFeedbackController()
            get { controller.getProductFeedbacks(call) }
            post { controller.addFeedback(call) }
        }
    }
}

private fun getFeedbackController(): FeedbackController {
    val repo = FeedbackRepositoryImpl()
    val useCase = FeedbackUseCaseImpl(repo)
    val controller = FeedbackControllerImpl(useCase)
    return controller
}
