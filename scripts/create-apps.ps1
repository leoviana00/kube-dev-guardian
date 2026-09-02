param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$AppsRoot = Join-Path $Root "apps"

Write-Host ""
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host " Kube Dev Guardian - Create Applications" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""

New-Item -ItemType Directory -Path $AppsRoot -Force | Out-Null

function Write-ProjectFile {
    param(
        [string]$Path,
        [string]$Content
    )

    $Directory = Split-Path -Parent $Path
    New-Item -ItemType Directory -Path $Directory -Force | Out-Null
    $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    $Bytes = $Utf8NoBom.GetBytes($Content)
    [System.IO.File]::WriteAllBytes($Path, $Bytes)
}

function Create-CustomerApi {
    $AppRoot = Join-Path $AppsRoot "customer-api"

    if ((Test-Path $AppRoot) -and (-not $Force)) {
        Write-Host "[SKIP] customer-api ja existe. Use -Force para recriar." -ForegroundColor Yellow
        return
    }

    Write-Host "[1/3] Criando customer-api..." -ForegroundColor Green

    $Pom = @"
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">

    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.5.7</version>
        <relativePath/>
    </parent>

    <groupId>com.kubedevguardian</groupId>
    <artifactId>customer-api</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>customer-api</name>
    <description>Kube Dev Guardian - Customer API</description>

    <properties>
        <java.version>21</java.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>

        <dependency>
            <groupId>io.micrometer</groupId>
            <artifactId>micrometer-registry-prometheus</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>
"@

    $Application = @"
package com.kubedevguardian.customer;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class CustomerApiApplication {

    public static void main(String[] args) {
        SpringApplication.run(CustomerApiApplication.class, args);
    }
}
"@

    $ApplicationYml = @"
spring:
  application:
    name: customer-api

server:
  port: 8080

management:
  endpoints:
    web:
      exposure:
        include: health,info,prometheus
  endpoint:
    health:
      show-details: never
"@

    $Test = @"
package com.kubedevguardian.customer;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class CustomerApiApplicationTest {

    @Test
    void contextLoads() {
    }
}
"@

    $Readme = @"
# customer-api

API REST de clientes do projeto Kube Dev Guardian.

## Stack

- Java 21
- Spring Boot 3.5.7
- Maven
- Spring Boot Actuator
- Micrometer Prometheus

## Execucao

```powershell
mvn spring-boot:run
```

## Endpoints de infraestrutura

- GET /actuator/health
- GET /actuator/info
- GET /actuator/prometheus
"@

    Write-ProjectFile (Join-Path $AppRoot "pom.xml") $Pom
    Write-ProjectFile (Join-Path $AppRoot "src\main\java\com\kubedevguardian\customer\CustomerApiApplication.java") $Application
    Write-ProjectFile (Join-Path $AppRoot "src\main\resources\application.yml") $ApplicationYml
    Write-ProjectFile (Join-Path $AppRoot "src\test\java\com\kubedevguardian\customer\CustomerApiApplicationTest.java") $Test
    Write-ProjectFile (Join-Path $AppRoot "README.md") $Readme

    Write-Host "[OK] customer-api criado." -ForegroundColor Green
}

function Create-OrderProducer {
    $AppRoot = Join-Path $AppsRoot "order-producer"

    if ((Test-Path $AppRoot) -and (-not $Force)) {
        Write-Host "[SKIP] order-producer ja existe. Use -Force para recriar." -ForegroundColor Yellow
        return
    }

    Write-Host "[2/3] Criando order-producer..." -ForegroundColor Green

    $Pom = @"
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">

    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.5.7</version>
        <relativePath/>
    </parent>

    <groupId>com.kubedevguardian</groupId>
    <artifactId>order-producer</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>order-producer</name>
    <description>Kube Dev Guardian - Order Producer</description>

    <properties>
        <java.version>21</java.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>
"@

    $Application = @"
package com.kubedevguardian.orderproducer;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class OrderProducerApplication {

    public static void main(String[] args) {
        SpringApplication.run(OrderProducerApplication.class, args);
    }
}
"@

    $ApplicationYml = @"
spring:
  application:
    name: order-producer
"@

    $Test = @"
package com.kubedevguardian.orderproducer;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class OrderProducerApplicationTest {

    @Test
    void contextLoads() {
    }
}
"@

    $Readme = @"
# order-producer

Servico produtor de pedidos do projeto Kube Dev Guardian.

A integracao com Kafka sera implementada na Feature F03.
"@

    Write-ProjectFile (Join-Path $AppRoot "pom.xml") $Pom
    Write-ProjectFile (Join-Path $AppRoot "src\main\java\com\kubedevguardian\orderproducer\OrderProducerApplication.java") $Application
    Write-ProjectFile (Join-Path $AppRoot "src\main\resources\application.yml") $ApplicationYml
    Write-ProjectFile (Join-Path $AppRoot "src\test\java\com\kubedevguardian\orderproducer\OrderProducerApplicationTest.java") $Test
    Write-ProjectFile (Join-Path $AppRoot "README.md") $Readme

    Write-Host "[OK] order-producer criado." -ForegroundColor Green
}

function Create-OrderConsumer {
    $AppRoot = Join-Path $AppsRoot "order-consumer"

    if ((Test-Path $AppRoot) -and (-not $Force)) {
        Write-Host "[SKIP] order-consumer ja existe. Use -Force para recriar." -ForegroundColor Yellow
        return
    }

    Write-Host "[3/3] Criando order-consumer..." -ForegroundColor Green

    $Pom = @"
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">

    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.5.7</version>
        <relativePath/>
    </parent>

    <groupId>com.kubedevguardian</groupId>
    <artifactId>order-consumer</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>order-consumer</name>
    <description>Kube Dev Guardian - Order Consumer</description>

    <properties>
        <java.version>21</java.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>
"@

    $Application = @"
package com.kubedevguardian.orderconsumer;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class OrderConsumerApplication {

    public static void main(String[] args) {
        SpringApplication.run(OrderConsumerApplication.class, args);
    }
}
"@

    $ApplicationYml = @"
spring:
  application:
    name: order-consumer
"@

    $Test = @"
package com.kubedevguardian.orderconsumer;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class OrderConsumerApplicationTest {

    @Test
    void contextLoads() {
    }
}
"@

    $Readme = @"
# order-consumer

Servico consumidor de pedidos do projeto Kube Dev Guardian.

A integracao com Kafka sera implementada na Feature F03.
"@

    Write-ProjectFile (Join-Path $AppRoot "pom.xml") $Pom
    Write-ProjectFile (Join-Path $AppRoot "src\main\java\com\kubedevguardian\orderconsumer\OrderConsumerApplication.java") $Application
    Write-ProjectFile (Join-Path $AppRoot "src\main\resources\application.yml") $ApplicationYml
    Write-ProjectFile (Join-Path $AppRoot "src\test\java\com\kubedevguardian\orderconsumer\OrderConsumerApplicationTest.java") $Test
    Write-ProjectFile (Join-Path $AppRoot "README.md") $Readme

    Write-Host "[OK] order-consumer criado." -ForegroundColor Green
}

Create-CustomerApi
Create-OrderProducer
Create-OrderConsumer

Write-Host ""
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host " Projetos criados em: $AppsRoot" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Proximo passo:" -ForegroundColor Yellow
Write-Host "  1. cd $Root"
Write-Host "  2. mvn -version"
Write-Host "  3. cd apps\customer-api"
Write-Host "  4. mvn test"
Write-Host ""
