terraform {
  required_version = "~> 1.3.6"
  backend "gcs" {
    prefix = "tfstate/v1"
  }
}

## project ##
provider "google" {
  project = var.gcp_project_id
  region  = var.primary_region
}

locals {
  frontend_app_name = "frontend"
}

module "artifact-registry" {
 source                     = "./modules/artifact-registry"
 gcp_project_id             = var.gcp_project_id
 artifact_registry_location = var.primary_region
 frontend_app_name          = local.frontend_app_name
}

module "cloud-run" {
  source         = "./modules/cloud-run"
  gcp_project_id = var.gcp_project_id
}

module "cloud-build" {
 source                      = "./modules/cloud-build"
 gcp_project_id              = var.gcp_project_id
 region                      = var.primary_region
 cloud_run_service_account   = module.cloud-run.cloud_runner_service_account
 frontend_app_name           = local.frontend_app_name
 github_owner                = "Kazuya-dx"
 github_app_repo_name        = "nextjs-gcp-starter-kit"
}