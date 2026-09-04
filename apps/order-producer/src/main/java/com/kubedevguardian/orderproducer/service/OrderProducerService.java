package com.kubedevguardian.orderproducer.service;

import com.kubedevguardian.orderproducer.model.OrderCreated;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.Instant;

@Service
public class OrderProducerService {

    private static final String TOPIC = "orders";

    private final KafkaTemplate<String, OrderCreated> kafkaTemplate;

    public OrderProducerService(KafkaTemplate<String, OrderCreated> kafkaTemplate) {
        this.kafkaTemplate = kafkaTemplate;
    }

    public void publish(OrderCreated order) {
        OrderCreated event = order;

        if (order.createdAt() == null) {
            event = new OrderCreated(
                    order.orderId(),
                    order.customerId(),
                    order.total(),
                    Instant.now()
            );
        }

        kafkaTemplate.send(
                TOPIC,
                event.orderId().toString(),
                event
        );
    }

    public void publishExampleOrder() {
        OrderCreated order = new OrderCreated(
                1001L,
                1L,
                new BigDecimal("149.90"),
                Instant.now()
        );

        publish(order);
    }
}