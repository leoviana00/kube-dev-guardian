package com.kubedevguardian.orderconsumer.listener;

import com.kubedevguardian.orderconsumer.model.OrderCreated;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.Instant;

import static org.junit.jupiter.api.Assertions.assertEquals;

class OrderConsumerListenerTest {

    @Test
    void shouldReceiveOrderCreatedEvent() {

        OrderCreated order = new OrderCreated(
                1002L,
                2L,
                new BigDecimal("249.90"),
                Instant.parse("2026-09-03T12:40:00Z")
        );

        assertEquals(1002L, order.orderId());
        assertEquals(2L, order.customerId());
        assertEquals(
                new BigDecimal("249.90"),
                order.total()
        );
        assertEquals(
                Instant.parse("2026-09-03T12:40:00Z"),
                order.createdAt()
        );
    }
}