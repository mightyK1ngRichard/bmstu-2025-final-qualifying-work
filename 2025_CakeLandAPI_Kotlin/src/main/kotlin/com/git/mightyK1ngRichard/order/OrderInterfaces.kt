package com.git.mightyK1ngRichard.order

import com.git.mightyK1ngRichard.order.models.OrderModel
import io.ktor.server.application.*

interface OrderController {
    suspend fun getUserOrders(call: ApplicationCall)
}

interface OrderUseCase {
    suspend fun getUserOrders(req: OrderModel.GetOrders.Request): OrderModel.GetOrders.Response
}

interface OrderRepository {
    suspend fun getUserOrders(req: OrderModel.GetOrders.Request): OrderModel.GetOrders.Response
}
