resource "google_pubsub_topic" "topic" {
  name    = var.topic_name
  project = var.project_id
  labels  = var.labels
}

resource "google_pubsub_subscription" "subscription" {
  name  = var.subscription_name
  topic = google_pubsub_topic.topic.name
  project = var.project_id

  ack_deadline_seconds = var.ack_deadline_seconds
}
