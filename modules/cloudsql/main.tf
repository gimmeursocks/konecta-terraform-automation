resource "google_sql_database_instance" "main" {
  project             = var.project_id
  name                = var.instance_name
  database_version    = var.database_version
  region              = var.region
  deletion_protection = var.deletion_protection

  settings {
    tier            = var.tier
    disk_size       = var.disk_size_gb
    disk_type       = var.disk_type
    disk_autoresize = var.disk_autoresize
  }
}

resource "google_sql_database" "databases" {
  for_each = toset(var.databases)

  project  = var.project_id
  name     = each.value
  instance = google_sql_database_instance.main.name
}

resource "google_sql_user" "db_users" {
  for_each = var.users

  project  = var.project_id
  name     = each.key
  instance = google_sql_database_instance.main.name
  password = each.value.password
}
