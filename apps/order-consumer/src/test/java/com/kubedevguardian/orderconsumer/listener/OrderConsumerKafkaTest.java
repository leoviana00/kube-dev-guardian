package com.kubedevguardian.orderconsumer.listener;

import com.kubedevguardian.orderconsumer.model.OrderCreated;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.serialization.StringSerializer;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.kafka.core.DefaultKafkaProducerFactory;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.test.context.EmbeddedKafka;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestPropertySource;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.HashMap;
import java.util.Map;

import static org.awaitility.Awaitility.await;
import static org.junit.jupiter.api.Assertions.assertEquals;

@SpringBootTest
@ActiveProfiles("test")
@EmbeddedKafka(
        partitions = 1,
        topics = "orders"
)
@TestPropertySource(properties = {
        "spring.kafka.bootstrap-servers=${spring.embedded.kafka.brokers}"
})
class OrderConsumerKafkaTest {

    @Autowired
    private OrderConsumerListener listener;

    @Test
    void shouldConsumeOrderCreatedEvent() {

        Map<String, Object> producerProperties = new HashMap<>();

        producerProperties.put(
                ProducerConfig.BOOTSTRAP_SERVERS_CONFIG,
                System.getProperty(
                        "spring.embedded.kafka.brokers"
                )
        );

        producerProperties.put(
                ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG,
                StringSerializer.class
        );

        producerProperties.put(
                ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG,
                StringSerializer.class
        );

        DefaultKafkaProducerFactory<String, String> producerFactory =
                new DefaultKafkaProducerFactory<>(producerProperties);

        KafkaTemplate<String, String> kafkaTemplate =
                new KafkaTemplate<>(producerFactory);

        String event = """
                {
                    "orderId": 2001,
                    "customerId": 10,
                    "total": 399.90,
                    "createdAt": "2026-09-03T14:00:00Z"
                }
                """;

        kafkaTemplate.send(
                "orders",
                "2001",
                event
        );

        await()
                .atMost(java.time.Duration.ofSeconds(10))
                .until(() -> listener.getLastReceivedOrder() != null);

        OrderCreated receivedOrder =
                listener.getLastReceivedOrder();

        assertEquals(2001L, receivedOrder.orderId());
        assertEquals(10L, receivedOrder.customerId());
        assertEquals(
                new BigDecimal("399.90"),
                receivedOrder.total()
        );
        assertEquals(
                Instant.parse("2026-09-03T14:00:00Z"),
                receivedOrder.createdAt()
        );

        kafkaTemplate.destroy();
    }
}