# リソース内で使用する変数。 main.tf から呼び出す際に引数のように値を代入できる。
variable "gcp_project_id" {}
variable "region" {}
variable "cloud_run_service_account" {}
variable "app_name" {}
variable "frontend_app_name" {}
variable "github_owner" {}
variable "github_app_repo_name" {}

# cloud build リソース。 main への push をトリガーとし cloudbuild.yml を実行する。
resource "google_cloudbuild_trigger" "deploy-frontend" {
  # トリガーの名前
  name        = "deploy-frontend"
  # 説明
  description = "Next.js App を Cloud Run へデプロイする"
  # リポジトリ
  github {
    # GitHub アカウントid (ex) Kazuya-dx/<repo-name> でいう Kazuya-dx
    owner = var.github_owner
    # GitHub 上のリポジトリ名 (ex) Kazuya-dx/<repo-name> でいう <repo-name>
    name  = var.github_app_repo_name
    # トリガーイベント
    push {
      branch = "^main$"
    }
  }
  # 含めるファイル
  included_files = ["frontend/**"]
  # Cloud Build 実行ファイル(cloudbuild.yml)のパス
  filename       = "frontend/cloudbuild.yml"
  # 代入変数 (cloudbuild.yml 実行時に置換する)
  substitutions = {
    _APP_NAME                       = var.app_name
    _REGION                         = var.region
    _SERVICE_ACCOUNT                = var.cloud_run_service_account
    _ARTIFACT_REPOSITORY_IMAGE_NAME = "${var.region}-docker.pkg.dev/${var.gcp_project_id}/${var.frontend_app_name}/${var.app_name}"
  }
}