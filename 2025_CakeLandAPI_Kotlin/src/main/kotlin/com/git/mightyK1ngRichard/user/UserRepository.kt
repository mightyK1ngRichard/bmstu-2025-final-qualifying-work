package com.git.mightyK1ngRichard.user

import com.git.mightyK1ngRichard.user.models.User
import com.git.mightyK1ngRichard.utils.DatabaseException
import com.git.mightyK1ngRichard.utils.DatabaseFactory
import java.sql.SQLException

class UserRepositoryImpl : UserRepository {
    companion object {
        private const val SELECT_ALL_USERS = "SELECT * FROM \"user\";"
    }

    override suspend fun getUsers(): List<User> {
        val connection = DatabaseFactory.getConnection()
        val users = mutableListOf<User>()
        try {
            connection.prepareStatement(SELECT_ALL_USERS).use { statement ->
                val resultSet = statement.executeQuery()
                while (resultSet.next()) {
                    users.add(
                        User(
                            id = resultSet.getString("id"),
                            fio = resultSet.getString("fio"),
                            mail = resultSet.getString("mail")
                        )
                    )
                }
            }
            return users
        } catch (e: SQLException) {
            throw DatabaseException("Error executing query: ${e.message}", e)
        } catch (e: Exception) {
            throw e
        } finally {
            connection.close() // Соединение будет возвращено в пул автоматически после закрытия
        }
    }
}
