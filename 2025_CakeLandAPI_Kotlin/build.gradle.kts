val h2_version: String by project
val kotlin_version: String by project
val logback_version: String by project
val postgres_version: String by project
val hikari_version: String by project

plugins {
    kotlin("jvm") version "2.1.10"
    id("io.ktor.plugin") version "3.0.3"
    id("org.jetbrains.kotlin.plugin.serialization") version "2.1.10"
    id("com.google.protobuf") version "0.9.4"
}

group = "com.git.mightyK1ngRichard"
version = "0.0.1"

application {
    mainClass.set("io.ktor.server.netty.EngineMain")

    val isDevelopment: Boolean = project.ext.has("development")
    applicationDefaultJvmArgs = listOf("-Dio.ktor.development=$isDevelopment")
}

repositories {
    mavenCentral()
}

dependencies {
    implementation("io.ktor:ktor-server-core")
    implementation("io.ktor:ktor-server-call-logging")
    implementation("io.ktor:ktor-server-content-negotiation")
    implementation("io.ktor:ktor-serialization-kotlinx-json")
    implementation("org.postgresql:postgresql:$postgres_version")
    implementation("com.h2database:h2:$h2_version")
    implementation("io.ktor:ktor-server-netty")
    implementation("ch.qos.logback:logback-classic:$logback_version")
    implementation("io.ktor:ktor-server-config-yaml")
    implementation("com.zaxxer:HikariCP:$hikari_version")
    testImplementation("io.ktor:ktor-server-test-host")
    testImplementation("org.jetbrains.kotlin:kotlin-test-junit:$kotlin_version")
    implementation("com.google.protobuf:protobuf-kotlin:4.28.2")
    api("io.grpc:grpc-protobuf:1.44.0")
    api("com.google.protobuf:protobuf-java-util:3.19.4")
    api("com.google.protobuf:protobuf-kotlin:3.19.4")
    api("io.grpc:grpc-kotlin-stub:1.2.1")
    api("io.grpc:grpc-stub:1.44.0")
}

//protobuf {
//    protoc {
//        artifact = "com.google.protobuf:protoc:3.19.4"
//    }
//    plugins {
//        id("grpc") {
//            artifact = "io.grpc:protoc-gen-grpc-java:1.44.0"
//        }
//        id("grpckt") {
//            artifact = "io.grpc:protoc-gen-grpc-kotlin:1.2.1:jdk7@jar"
//        }
//    }
//    generateProtoTasks {
//        all().forEach {
//            it.plugins {
//                id("grpc")
//                id("grpckt")
//            }
//            it.builtins {
//                id("kotlin")
//            }
//        }
//    }
//}