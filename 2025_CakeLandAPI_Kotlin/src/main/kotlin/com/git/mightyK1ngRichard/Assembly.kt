package com.git.mightyK1ngRichard

import com.git.mightyK1ngRichard.feedback.FeedbackController
import com.git.mightyK1ngRichard.feedback.FeedbackControllerImpl
import com.git.mightyK1ngRichard.feedback.FeedbackRepositoryImpl
import com.git.mightyK1ngRichard.feedback.FeedbackUseCaseImpl
import com.git.mightyK1ngRichard.order.OrderController
import com.git.mightyK1ngRichard.order.OrderControllerImpl
import com.git.mightyK1ngRichard.order.OrderRepositoryImpl
import com.git.mightyK1ngRichard.order.OrderUseCaseImpl
import java.sql.Connection

object Assembly {
    fun makeFeedbackController(connection: Connection): FeedbackController {
        val repo = FeedbackRepositoryImpl(connection)
        val useCase = FeedbackUseCaseImpl(repo)
        val controller = FeedbackControllerImpl(useCase)
        return controller
    }

    fun makeOrderController(connection: Connection): OrderController {
        val repo = OrderRepositoryImpl(connection)
        val useCase = OrderUseCaseImpl(repo)
        val controller = OrderControllerImpl(useCase)
        return controller
    }
}