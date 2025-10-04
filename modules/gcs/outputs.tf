output "bucket_names" {
  description = "Names of the created buckets"
  value       = { for k, v in google_storage_bucket.buckets : k => v.name }
}

output "bucket_urls" {
  description = "Public URL of the buckets"
  value       = { for k, v in google_storage_bucket.buckets : k => v.url }
}

output "bucket_self_links" {
  description = "API self links of the buckets"
  value       = { for k, v in google_storage_bucket.buckets : k => v.self_link }
}
