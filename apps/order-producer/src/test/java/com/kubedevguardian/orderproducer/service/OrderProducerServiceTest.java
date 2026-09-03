package com.kubedevguardian.orderproducer.service;

import com.kubedevguardian.orderproducer.model.OrderCreated;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.kafka.core.KafkaTemplate;

import java.math.BigDecimal;
import java.time.Instant;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.verify;

@ExtendWith(MockitoExtension.class)
class OrderProducerServiceTest {

    @Mock
    private KafkaTemplate<String, OrderCreated> kafkaTemplate;

    @InjectMocks
    private OrderProducerService orderProducerService;

    @Test
    void shouldPublishOrderToOrdersTopic() {

        OrderCreated order = new OrderCreated(
                1001L,
                1L,
                new BigDecimal("149.90"),
                Instant.parse("2026-09-03T12:40:00Z")
        );

        orderProducerService.publish(order);

        ArgumentCaptor<String> topicCaptor =
                ArgumentCaptor.forClass(String.class);

        ArgumentCaptor<String> keyCaptor =
                ArgumentCaptor.forClass(String.class);

        ArgumentCaptor<OrderCreated> orderCaptor =
                ArgumentCaptor.forClass(OrderCreated.class);

        verify(kafkaTemplate).send(
                topicCaptor.capture(),
                keyCaptor.capture(),
                orderCaptor.capture()
        );

        assertEquals("orders", topicCaptor.getValue());
        assertEquals("1001", keyCaptor.getValue());

        OrderCreated publishedOrder = orderCaptor.getValue();

        assertEquals(1001L, publishedOrder.orderId());
        assertEquals(1L, publishedOrder.customerId());
        assertEquals(
                new BigDecimal("149.90"),
                publishedOrder.total()
        );
        assertEquals(
                Instant.parse("2026-09-03T12:40:00Z"),
                publishedOrder.createdAt()
        );
    }
}