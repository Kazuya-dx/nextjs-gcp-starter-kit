# リソース内で使用する変数。 main.tf から呼び出す際に引数のように値を代入できる。
variable "gcp_project_id" {}
variable "frontend_app_name" {}
variable "artifact_registry_location" {
  type = string
  # https://cloud.google.com/storage/docs/locations
  description = "ASIA-NORTHEAST1"
}

# frontendアプリケーション用の Artifact Registry リポジトリ
resource "google_artifact_registry_repository" "frontend" {
  provider = google-beta

  project       = var.gcp_project_id
  location      = var.artifact_registry_location
  repository_id = var.frontend_app_name
  description   = "フロントエンドアプリケーション"
  format        = "DOCKER"
}