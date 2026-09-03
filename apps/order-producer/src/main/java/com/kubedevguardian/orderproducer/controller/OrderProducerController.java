package com.kubedevguardian.orderproducer.controller;

import com.kubedevguardian.orderproducer.model.OrderCreated;
import com.kubedevguardian.orderproducer.service.OrderProducerService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/orders")
public class OrderProducerController {

    private final OrderProducerService orderProducerService;

    public OrderProducerController(OrderProducerService orderProducerService) {
        this.orderProducerService = orderProducerService;
    }

    @PostMapping
    public ResponseEntity<Void> createOrder(
            @RequestBody OrderCreated order) {

        orderProducerService.publish(order);

        return ResponseEntity.accepted().build();
    }
}