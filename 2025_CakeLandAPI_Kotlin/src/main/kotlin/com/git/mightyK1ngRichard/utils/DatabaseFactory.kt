package com.git.mightyK1ngRichard.utils

import com.zaxxer.hikari.HikariConfig
import com.zaxxer.hikari.HikariDataSource
import java.sql.Connection
import java.sql.SQLException

//object DatabaseFactory {
//    private const val URL = "jdbc:postgresql://localhost:5432/CakeLandDatabase"
//    private const val USER = "mightyK1ngRichard"
//    private const val PASSWORD = "kingPassword"
//
//    init {
//        try {
//            Class.forName("org.postgresql.Driver")
//        } catch (e: ClassNotFoundException) {
//            throw RuntimeException("PostgreSQL JDBC Driver не найден", e)
//        }
//    }
//
//    fun getConnection(): Connection {
//        return try {
//            DriverManager.getConnection(URL, USER, PASSWORD)
//        } catch (e: SQLException) {
//            throw RuntimeException("Ошибка подключения к БД", e)
//        }
//    }
//}

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

    // Метод для получения соединения из пула
    fun getConnection(): Connection {
        return try {
            dataSource.connection
        } catch (e: SQLException) {
            throw RuntimeException("Ошибка получения соединения из пула", e)
        }
    }
}