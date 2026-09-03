package com.kubedevguardian.orderconsumer.model;

import java.math.BigDecimal;
import java.time.Instant;

public record OrderCreated(
        Long orderId,
        Long customerId,
        BigDecimal total,
        Instant createdAt
) {
}