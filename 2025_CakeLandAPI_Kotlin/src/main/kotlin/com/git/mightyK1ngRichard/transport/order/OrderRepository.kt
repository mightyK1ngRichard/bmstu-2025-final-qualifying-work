package com.git.mightyK1ngRichard.transport.order

import com.git.mightyK1ngRichard.models.DatabaseException
import com.git.mightyK1ngRichard.transport.order.models.OrderModel
import java.sql.SQLException
import java.sql.Connection

class OrderRepositoryImpl(private val connection: Connection) : OrderRepository {
    companion object {
        private const val SELECT_USER_ORDERS = """
            SELECT o.id,
                   o.price,
                   o.delivery_address,
                   o.delivery_date,
                   o.customer_id,
                   o.seller_id,
                   o.cake_id,
                   o.status,
            
                   u.id               AS seller_uid,
                   u.fio              AS seller_fio,
                   u.mail             AS seller_mail,
                   u.image_url        AS seller_image_url,
                   customer.id        AS customer_uid,
                   customer.fio       AS customer_fio,
                   customer.mail      AS customer_mail,
                   customer.image_url AS customer_image_url,
            
                   c.id               AS cake_id,
                   c.name             AS cake_name,
                   c.image_url        AS cake_image_url,
                   c.kg_price         AS cake_kg_price,
                   c.rating           AS cake_rating,
                   c.description      AS cake_description,
                   c.mass             AS cake_mass
            FROM "order" o
                     LEFT JOIN "user" u ON u.id = o.seller_id
                     LEFT JOIN "user" customer ON customer_id = customer.id
                     LEFT JOIN "cake" c ON c.id = o.cake_id
            WHERE customer_id = ?::uuid;
        """
    }

    override suspend fun getUserOrders(req: OrderModel.GetOrders.Request): OrderModel.GetOrders.Response {
        val orders = mutableListOf<OrderModel.GetOrders.Response.Order>()
        try {
            connection.prepareStatement(SELECT_USER_ORDERS).use { statement ->
                statement.setString(1, req.userUID)
                val resultSet = statement.executeQuery()
                while (resultSet.next()) {
                    orders.add(
                        OrderModel.GetOrders.Response.Order(
                            uid = resultSet.getString("id"),
                            price = resultSet.getDouble("price"),
                            deliveryAddress = resultSet.getString("delivery_address"),
                            deliveryDate = resultSet.getDate("delivery_date")?.toLocalDate().toString(),
                            cake = OrderModel.GetOrders.Response.Order.Cake(
                                uid = resultSet.getString("cake_id"),
                                name = resultSet.getString("cake_name"),
                                imageURL = resultSet.getString("cake_image_url"),
                                kgPrice = resultSet.getDouble("cake_kg_price"),
                                rating = resultSet.getDouble("cake_rating"),
                                description = resultSet.getString("cake_description"),
                                mass = resultSet.getDouble("cake_mass"),
                            ),
                            customer = OrderModel.GetOrders.Response.Order.User(
                                uid = resultSet.getString("customer_uid"),
                                fio = resultSet.getString("customer_fio"),
                                imageURL = resultSet.getString("customer_image_url")
                            ),
                            seller = OrderModel.GetOrders.Response.Order.User(
                                uid = resultSet.getString("seller_uid"),
                                fio = resultSet.getString("seller_fio"),
                                imageURL = resultSet.getString("seller_image_url")
                            ),
                            status = OrderModel.GetOrders.Response.Order.Status.fromString(
                                resultSet.getString("status")
                            ) ?: OrderModel.GetOrders.Response.Order.Status.PENDING
                        )
                    )
                }
            }
            return OrderModel.GetOrders.Response(orders = orders)
        } catch (e: SQLException) {
            throw DatabaseException("Error executing query: ${e.message}", e)
        } catch (e: Exception) {
            throw e
        }
    }
}
