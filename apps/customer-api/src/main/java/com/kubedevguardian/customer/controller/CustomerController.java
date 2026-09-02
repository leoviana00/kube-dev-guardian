package com.kubedevguardian.customer.controller;

import com.kubedevguardian.customer.model.Customer;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@RestController
@RequestMapping("/api/customers")
public class CustomerController {

    private final List<Customer> customers = List.of(
            new Customer(1L, "Alice Silva", "alice@example.com"),
            new Customer(2L, "Bruno Santos", "bruno@example.com"),
            new Customer(3L, "Carla Oliveira", "carla@example.com")
    );

    @GetMapping
    public List<Customer> findAll() {
        return customers;
    }

    @GetMapping("/{id}")
    public Customer findById(@PathVariable Long id) {
        return customers.stream()
                .filter(customer -> customer.id().equals(id))
                .findFirst()
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        "Customer not found"
                ));
    }
}