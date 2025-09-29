output "bucket_name" {
  description = "Name of the created bucket."
  value       = google_storage_bucket.bucket.name
}

output "bucket_url" {
  description = "Public URL of the bucket."
  value       = "gs://${google_storage_bucket.bucket.name}"
}

output "bucket_self_link" {
  description = "API self link of the bucket."
  value       = google_storage_bucket.bucket.self_link
}
