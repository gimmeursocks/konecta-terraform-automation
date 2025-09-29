provider "google" {
  project = var.project_id
  region  = var.region
}

module "network" {
  source      = "./modules/vpc"
  project_id  = var.project_id
  vpc_name    = var.vpc_name
  subnet_name = var.subnet_name
  cidr        = var.cidr
  region      = var.region
}

module "storage" {
  source         = "./modules/storage"
  project_id     = var.project_id
  my_bucket_name = var.my_bucket_name 
  location       = var.location
}

module "compute" {
  source        = "./modules/cloud compute"
  instance_name = var.instance_name
  machine_type  = var.machine_type
  image         = var.image
  network       = module.network.vpc_name
} 

module "cloud_sql" {
  source           = "./modules/cloud SQL"
  instance_name    = var.sql_instance_name
  database_version = var.database_version
  region           = var.region
  machine_type     = var.sql_machine_type
}

module "cloud_run" {
  source        = "./modules/cloud run"
  cloudrun_name = var.cloudrun_name
  location      = var.location
  image         = var.image
}