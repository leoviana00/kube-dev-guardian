package com.kubedevguardian.customer.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI customerApiOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Customer API")
                        .description("API de clientes da PoC Kube Dev Guardian")
                        .version("1.0.0"));
    }
}