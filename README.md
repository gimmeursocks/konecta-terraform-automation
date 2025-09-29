# Konecta Terraform Automation

This repository contains Terraform modules for automating infrastructure deployment[In progress]. Below is an overview of the available modules:

## Modules

- **project**
    Create GCP project, billing, IAM, enable base APIs

- **vpc**  
    Networking backbone: custom VPC, subnets, firewall

- **gcs**  
    Basic storage buckets for state/files/assets

- **compute**  
    VM templates / instance groups for workloads

- **cloudsql**  
    Managed relational database

- **cloudrun**  
    Cloud Run services

- **gke**  
    Kubernetes cluster & node pools (needs VPC ready)

- **loadbalancer**  
    HTTP/S LB fronting Compute or GKE

- **pubsub**  
    Messaging & eventing infrastructure

- **monitoring**  
    Cloud Monitoring & Logging, alerts, dashboards

### Usage

To use a module, include it in your Terraform configuration:

```hcl
module "network" {
    source = "./modules/network"
    # module-specific variables
}
```

### Getting Started

1. Clone the repository
2. Initialize Terraform:  
     `terraform init`
3. Authenticate GCP
4. Fill in your variables
5. Apply your configuration:  
     `terraform apply`
