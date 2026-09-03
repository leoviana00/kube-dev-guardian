package com.kubedevguardian.orderconsumer.listener;

import com.kubedevguardian.orderconsumer.model.OrderCreated;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Component
public class OrderConsumerListener {

    @KafkaListener(
            topics = "orders",
            groupId = "order-consumer"
    )
    public void consume(OrderCreated order) {

        System.out.println(
                "Order received: " + order
        );
    }
}