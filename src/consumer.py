"""Minimal Kafka consumer for the fraud-alerts topic.

Configuration is supplied through environment variables so credentials are
never committed to the repository.
"""

import json
import os

from confluent_kafka import Consumer


def build_consumer() -> Consumer:
    return Consumer(
        {
            "bootstrap.servers": os.environ["KAFKA_BOOTSTRAP_SERVERS"],
            "security.protocol": os.getenv("KAFKA_SECURITY_PROTOCOL", "SASL_SSL"),
            "sasl.mechanisms": os.getenv("KAFKA_SASL_MECHANISMS", "PLAIN"),
            "sasl.username": os.environ["KAFKA_SASL_USERNAME"],
            "sasl.password": os.environ["KAFKA_SASL_PASSWORD"],
            "group.id": os.getenv("KAFKA_GROUP_ID", "fraud-alert-consumer"),
            "auto.offset.reset": "earliest",
            "enable.auto.commit": False,
        }
    )


def main() -> None:
    consumer = build_consumer()
    consumer.subscribe([os.getenv("FRAUD_ALERT_TOPIC", "fraud-alerts")])

    try:
        while True:
            message = consumer.poll(1.0)
            if message is None:
                continue
            if message.error():
                print(f"Kafka error: {message.error()}")
                continue

            payload = message.value()
            try:
                payload = json.loads(payload.decode("utf-8"))
            except (UnicodeDecodeError, json.JSONDecodeError):
                payload = payload.decode("utf-8", errors="replace")

            print(
                f"ALERT partition={message.partition()} "
                f"offset={message.offset()} payload={payload}"
            )

            # Commit only after the application has successfully handled the
            # alert. Replace this point with the real business action.
            consumer.commit(message=message, asynchronous=False)
    finally:
        consumer.close()


if __name__ == "__main__":
    main()
