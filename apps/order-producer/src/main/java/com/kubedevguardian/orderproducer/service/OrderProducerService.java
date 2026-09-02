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
        kafkaTemplate.send(TOPIC, order.orderId().toString(), order);
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