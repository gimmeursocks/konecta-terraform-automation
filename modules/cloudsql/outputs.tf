output "instance_connection_name" {
  description = "Cloud SQL connection name for use in apps."
  value       = google_sql_database_instance.main.connection_name
}

output "instance_ip_address" {
  description = "IP address of the instance"
  value       = google_sql_database_instance.main.ip_address
}

output "instance_self_link" {
  description = "Self link of the Cloud SQL instance."
  value       = google_sql_database_instance.main.self_link
}

output "database_names" {
  description = "List of created databases"
  value       = [for db in google_sql_database.databases : db.name]
}
