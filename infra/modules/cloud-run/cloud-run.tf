variable "gcp_project_id" {
  description = "GCP の project_id"
  type        = string
}

# CloudRunを実行するサービスアカウント
resource google_service_account app_runner {
  project = var.gcp_project_id
  account_id = "app-runner"
  display_name = "Cloud RunnerService Account"
}

# 編集者に追加
resource "google_project_iam_member" "app_runner_member" {
  project = var.gcp_project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.app_runner.email}"
}

# Cloud Run 起動者 に追加
resource "google_project_iam_member" "cloud_runner_member" {
  project = var.gcp_project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.app_runner.email}"
}

# Cloud Run サービスエージェント に追加
resource "google_project_iam_member" "cloud_runner_service_agent" {
  project = var.gcp_project_id
  role    = "roles/run.serviceAgent"
  member  = "serviceAccount:${google_service_account.app_runner.email}"
}

# Secret Manager のシークレット アクセサー に追加
resource "google_project_iam_member" "secret_accessor_member" {
  project = var.gcp_project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.app_runner.email}"
}

output "cloud_runner_service_account" {
  value = google_service_account.app_runner.email
}