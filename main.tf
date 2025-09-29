module "network" {
  source      = "./modules/vpc"
  project_id  = var.project_id
  vpc_name    = var.vpc_name
  subnet_name = var.subnet_name
  cidr        = var.cidr
  region      = var.region
}

module "storage" {
  source         = "./modules/gcs"
  my-bucket-name = var.my_bucket_name 
  location       = var.location
}

module "compute" {
  source        = "./modules/compute"
  instance_name = var.instance_name
  machine_type  = var.machine_type
  image         = var.image
  network       = module.network.vpc_name
} 

module "cloud_sql" {
  source           = "./modules/cloudsql"
  instance_name    = var.sql_instance_name
  database_version = var.database_version
  region           = var.region
  machine_type     = var.sql_machine_type
}

module "cloud_run" {
  source        = "./modules/serverless"
  cloudrun_name = var.cloudrun_name
  location      = var.location
  image         = var.image
}