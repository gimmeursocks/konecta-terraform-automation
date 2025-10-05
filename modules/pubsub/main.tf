resource "google_pubsub_topic" "topics" {
  for_each = var.topics

  project = var.project_id
  name    = each.key
  labels  = merge(var.labels, lookup(each.value, "labels", {}))

  message_retention_duration = lookup(each.value, "message_retention_duration", "86400s")
}

resource "google_pubsub_subscription" "subscriptions" {
  for_each = var.subscriptions

  project = var.project_id
  name    = each.key
  topic   = google_pubsub_topic.topics[each.value.topic].name

  ack_deadline_seconds       = lookup(each.value, "ack_deadline_seconds", 10)
  message_retention_duration = lookup(each.value, "message_retention_duration", "604800s")
  labels                     = merge(var.labels, lookup(each.value, "labels", {}))
}

resource "google_pubsub_topic_iam_member" "topic_members" {
  for_each = var.topic_iam_members

  project = var.project_id
  topic   = google_pubsub_topic.topics[each.value.topic].name
  role    = each.value.role
  member  = each.value.member
}

resource "google_pubsub_subscription_iam_member" "subscription_members" {
  for_each = var.subscription_iam_members

  project      = var.project_id
  subscription = google_pubsub_subscription.subscriptions[each.value.subscription].name
  role         = each.value.role
  member       = each.value.member
}