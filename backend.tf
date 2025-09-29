terraform {
  backend "gcs" {
    bucket = "konecta-autogcp-terraform-state-bucket"
    prefix = "terraform/prod"
  }
}