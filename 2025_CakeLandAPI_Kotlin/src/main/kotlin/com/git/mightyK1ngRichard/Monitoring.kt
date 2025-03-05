package com.git.mightyK1ngRichard

import com.git.mightyK1ngRichard.feedback.FeedbackController
import com.git.mightyK1ngRichard.feedback.FeedbackControllerImpl
import com.git.mightyK1ngRichard.feedback.FeedbackRepositoryImpl
import com.git.mightyK1ngRichard.feedback.FeedbackUseCaseImpl
import com.git.mightyK1ngRichard.order.OrderController
import com.git.mightyK1ngRichard.order.OrderControllerImpl
import com.git.mightyK1ngRichard.order.OrderRepositoryImpl
import com.git.mightyK1ngRichard.order.OrderUseCaseImpl
import io.ktor.server.application.*
import io.ktor.server.plugins.calllogging.*
import io.ktor.server.request.*
import org.slf4j.event.*
import java.sql.Connection

fun Application.configureMonitoring() {
    install(CallLogging) {
        level = Level.INFO
        filter { call -> call.request.path().startsWith("/") }
    }
    log.debug("")
}
