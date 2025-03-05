package com.git.mightyK1ngRichard.main

import com.git.mightyK1ngRichard.transport.feedback.FeedbackController
import com.git.mightyK1ngRichard.transport.feedback.FeedbackControllerImpl
import com.git.mightyK1ngRichard.transport.feedback.FeedbackRepositoryImpl
import com.git.mightyK1ngRichard.transport.feedback.FeedbackUseCaseImpl
import com.git.mightyK1ngRichard.transport.order.OrderController
import com.git.mightyK1ngRichard.transport.order.OrderControllerImpl
import com.git.mightyK1ngRichard.transport.order.OrderRepositoryImpl
import com.git.mightyK1ngRichard.transport.order.OrderUseCaseImpl
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