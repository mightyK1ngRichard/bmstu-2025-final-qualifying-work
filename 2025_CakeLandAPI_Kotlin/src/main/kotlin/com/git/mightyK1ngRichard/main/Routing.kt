package com.git.mightyK1ngRichard.main

import com.git.mightyK1ngRichard.pkg.managers.DatabaseFactory
import io.ktor.server.application.*
import io.ktor.server.routing.*

fun Application.configureRouting() {
    val dbConnection = DatabaseFactory.getConnection()
    val feedbackController = Assembly.makeFeedbackController(dbConnection)
    val orderController = Assembly.makeOrderController(dbConnection)

    routing {
        route("/feedbacks") {
            get { feedbackController.getProductFeedbacks(call) }
            post { feedbackController.addFeedback(call) }
        }

        route("/orders") {
            get { orderController.getUserOrders(call) }
        }
    }
}
