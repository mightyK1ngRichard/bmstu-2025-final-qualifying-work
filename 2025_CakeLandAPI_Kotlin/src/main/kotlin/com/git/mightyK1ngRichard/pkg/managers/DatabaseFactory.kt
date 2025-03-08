package com.git.mightyK1ngRichard.pkg.managers

import com.zaxxer.hikari.HikariConfig
import com.zaxxer.hikari.HikariDataSource
import java.sql.Connection
import java.sql.SQLException

object DatabaseFactory {
    private val dataSource: HikariDataSource

    init {
        val config = HikariConfig().apply {
            jdbcUrl = "jdbc:postgresql://localhost:5432/CakeLandDatabase"
            username = "mightyK1ngRichard"
            password = "kingPassword"
            driverClassName = "org.postgresql.Driver"
            maximumPoolSize = 10
        }
        dataSource = HikariDataSource(config)
    }

    fun getConnection(): Connection {
        return try {
            dataSource.connection
        } catch (e: SQLException) {
            throw RuntimeException("Ошибка получения соединения из пула", e)
        }
    }
}
