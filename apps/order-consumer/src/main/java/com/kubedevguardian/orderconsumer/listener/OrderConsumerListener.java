package com.kubedevguardian.orderconsumer.listener;

import com.kubedevguardian.orderconsumer.model.OrderCreated;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Component
public class OrderConsumerListener {

    private OrderCreated lastReceivedOrder;

    @KafkaListener(
            topics = "orders",
            groupId = "order-consumer"
    )
    public void consume(OrderCreated order) {

        this.lastReceivedOrder = order;

        System.out.println(
                "Order received: " + order
        );
    }

    public OrderCreated getLastReceivedOrder() {
        return lastReceivedOrder;
    }
}