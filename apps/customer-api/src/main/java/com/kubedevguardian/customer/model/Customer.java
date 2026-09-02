package com.kubedevguardian.customer.model;

public record Customer(
        Long id,
        String name,
        String email
) {
}