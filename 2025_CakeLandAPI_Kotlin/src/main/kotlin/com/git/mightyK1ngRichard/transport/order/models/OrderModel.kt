package com.git.mightyK1ngRichard.transport.order.models

import kotlinx.serialization.Serializable
import java.time.LocalDate


sealed class OrderModel {
    sealed class GetOrders {
        data class Request(
            val userUID: String,
            val expiresIn: Long,
        )

        @Serializable
        data class Response(
            val orders: List<Order>
        ) {
            @Serializable
            data class Order(
                val uid: String,
                val price: Double,
                val deliveryAddress: String?,
                val deliveryDate: String?,
                val cake: Cake,
                val customer: User,
                val seller: User,
                val status: Status
            ) {
                @Serializable
                data class User(
                    val uid: String,
                    val fio: String?,
                    val imageURL: String?,
                )

                @Serializable
                data class Cake(
                    val uid: String,
                    val name: String,
                    val imageURL: String?,
                    val kgPrice: Double,
                    val rating: Double,
                    val description: String?,
                    val mass: Double
                )

                enum class Status(val status: String) {
                    PENDING("pending"), // Ожидает выполнения
                    SHIPPED("shipped"), // Отправлен
                    DELIVERED("delivered"), // Доставлен
                    CANCELLED("cancelled");  // Отменён

                    companion object {
                        fun fromString(value: String): Status? {
                            return values().find { it.status.equals(value, ignoreCase = true) }
                        }
                    }
                }
            }
        }
    }
}