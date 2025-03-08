package com.git.mightyK1ngRichard.transport.order

import com.git.mightyK1ngRichard.pkg.extensions.isExpired
import com.git.mightyK1ngRichard.models.UnauthorizedException
import com.git.mightyK1ngRichard.transport.order.models.OrderModel


class OrderUseCaseImpl(private val repository: OrderRepository) : OrderUseCase {
    override suspend fun getUserOrders(req: OrderModel.GetOrders.Request): OrderModel.GetOrders.Response {
        if (req.expiresIn.isExpired()) {
            throw UnauthorizedException("Access token is expired")
        }

        return repository.getUserOrders(req)
    }
}
