output "topic_names" {
  description = "The name of the created Pub/Sub topics"
  value       = { for k, v in google_pubsub_topic.topics : k => v.name }
}

output "subscription_names" {
  description = "The name of the created Pub/Sub subscriptions"
  value       = { for k, v in google_pubsub_subscription.subscriptions : k => v.name }
}
