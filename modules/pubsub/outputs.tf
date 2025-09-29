output "topic_name" {
  description = "The name of the created Pub/Sub topic."
  value       = google_pubsub_topic.topic.name
}

output "subscription_name" {
  description = "The name of the created Pub/Sub subscription."
  value       = google_pubsub_subscription.subscription.name
}
