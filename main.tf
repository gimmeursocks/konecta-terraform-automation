module "project" {
  source          = "./modules/project"
  project_id      = var.project_id
  billing_account = var.billing_account
  organization_id = var.organization_id
}

module "vpc" {
  source      = "./modules/vpc"
  project_id  = var.project_id
  vpc_name    = var.vpc_name
  subnet_name = var.subnet_name
  cidr        = var.cidr
  region      = var.region
}

module "gcs" {
  source        = "./modules/gcs"
  project_id    = var.project_id
  bucket_name   = var.bucket_name
  location      = var.location
  storage_class = var.storage_class
  force_destroy = var.force_destroy

  labels = var.labels

  versioning     = var.versioning
  uniform_access = var.uniform_access
}

module "compute" {
  source        = "./modules/compute"
  project_id    = var.project_id
  instance_name = var.instance_name
  machine_type  = var.machine_type
  zone          = var.zone

  image        = var.image
  disk_size_gb = var.disk_size_gb

  network    = module.vpc.network_self_link
  subnetwork = module.vpc.subnet_self_link

  tags = var.tags
}

module "cloud_sql" {
  source              = "./modules/cloudsql"
  project_id          = var.project_id
  instance_name       = var.sql_instance_name
  database_version    = var.database_version
  region              = var.region
  deletion_protection = var.deletion_protection

  machine_type = var.sql_machine_type

  db_name     = var.db_name
  db_user     = var.db_user
  db_password = var.db_password
}

module "cloudrun" {
  source        = "./modules/cloudrun"
  project_id    = var.project_id
  cloudrun_name = var.cloudrun_name
  location      = var.region
  image         = var.cloudrun_image
  env_vars      = var.cloudrun_env_vars

  allow_unauthenticated = var.cloudrun_allow_unauthenticated
}

module "gke" {
  source       = "./modules/gke"
  project_id   = var.project_id
  cluster_name = var.gke_cluster_name
  region       = var.region
  network      = module.vpc.network_self_link
  subnetwork   = module.vpc.subnet_self_link

  machine_type = var.gke_machine_type
  node_count   = var.gke_node_count
}

module "loadbalancer" {
  source     = "./modules/loadbalancer"
  project_id = var.project_id
  name       = var.lb_name
}

module "pubsub" {
  source            = "./modules/pubsub"
  project_id        = var.project_id
  topic_name        = var.topic_name
  subscription_name = var.subscription_name
  labels            = var.pubsub_labels
}

module "monitoring" {
  source        = "./modules/monitoring"
  project_id    = var.project_id
  name_prefix   = var.alert_name_prefix
  cpu_threshold = var.alert_cpu_threshold
  logs_bucket   = var.monitoring_logs_bucket
}
