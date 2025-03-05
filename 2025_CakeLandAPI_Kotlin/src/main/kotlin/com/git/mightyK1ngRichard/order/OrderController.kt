package com.git.mightyK1ngRichard.order

import com.git.mightyK1ngRichard.models.DatabaseException
import com.git.mightyK1ngRichard.models.UnauthorizedException
import com.git.mightyK1ngRichard.models.errorResponse
import com.git.mightyK1ngRichard.order.models.OrderModel
import com.git.mightyK1ngRichard.utils.JWTManager
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.response.*

class OrderControllerImpl(private val useCase: OrderUseCase) : OrderController {
    override suspend fun getUserOrders(call: ApplicationCall) {
        try {
            // Достаём данные из jwt
            val decodedJWT = JWTManager.getDecodedJWT(call)
            val userID = decodedJWT.getClaim("user_id").asString()
            val expiresIn = decodedJWT.getClaim("exp").asLong()
            val responseDTO = useCase.getUserOrders(OrderModel.GetOrders.Request(userID, expiresIn))
            call.respond(responseDTO)
        } catch (e: DatabaseException) {
            call.errorResponse(HttpStatusCode.InternalServerError, "Database error: ${e.message}")
        } catch (e: UnauthorizedException) {
            call.errorResponse(e.code, "Unauthorized exception: ${e.message}")
        } catch (e: Exception) {
            call.errorResponse(HttpStatusCode.InternalServerError, "Unexpected error: ${e.message}")
        }
    }
}
