output "instance_connection_name" {
  description = "Cloud SQL connection name for use in apps."
  value       = google_sql_database_instance.db_instance.connection_name
}

output "instance_self_link" {
  description = "Self link of the Cloud SQL instance."
  value       = google_sql_database_instance.db_instance.self_link
}

output "db_name" {
  description = "Name of the created database."
  value       = google_sql_database.database.name
}
