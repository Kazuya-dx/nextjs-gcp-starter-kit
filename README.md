# ⚡️ **Installation**

## 事前に必要なもの

- Google Cloud Platform プロジェクト
- GitHub リポジトリ

下記リンクよりそれぞれ作成してください。

Google Cloud Platform: [https://console.cloud.google.com/projectcreate](https://console.cloud.google.com/projectcreate)

GitHub: [https://github.com/new](https://github.com/new)

<br />

## 準備

gcloud コマンドを使用する際の Google アカウントを指定するために、下記コマンドを実行し Google Cloud Platform の認証を行ってください。認証はプロジェクトを作成したアカウントで行うようにしましょう。

```bash
gcloud auth login
```

<br />

同様にアプリケーションデフォルトの認証情報を設定するために下記コマンドを実行してください。

```bash
gcloud auth application-default login
```

<br />

作成したプロジェクト用のコンフィグを作成します。gcloud コマンドが使用できない場合は [こちら](https://cloud.google.com/sdk/docs/install?hl=ja) を参考にインストールしてください。

```bash
gcloud config configurations create <プロジェクトid>
```

<aside>
💡 下記コマンドでアクティブになっている config の確認、指定 config のアクティブ化ができます。

</aside>

```bash
# アクティブになっている config の確認
gcloud config configurations list

# 指定 config のアクティブ化
gcloud config configurations activate <config名>
```

<br />

作成した config に プロジェクト id, email のメタ情報を紐づけましょう。

```bash
gcloud config set core/account <メールアドレス>
gcloud config set core/project <プロジェクトid>
```

<br />

下記コマンドを実行し Cloud Storage バケットを作成してください。ここで作成したバケットに terraform リソースが保存されるようになってます。

```bash
gsutil mb -l asia-northeast1 gs://<任意のバケット名>
```

<br />

infra/tf.sh に実行権限を付与してください。

```bash
chmod +x infra/tf.sh
```

<br />

作成したバケット上で terraform リソースを作成しましょう。

```bash
cd infra
./tf.sh init -backend-config="bucket=<作成したバケット名>"
# 例 ./tf.sh init -backend-config="bucket=nextjs_gcp_starter_kit"
```

実行に成功すると、`gs://<作成したバケット名>/tfstate/v1` に状態管理ファイルである `default.tfstate` が生成されます。

<br />

infra ディレクトリ内にある `terraform.tfvars.sample` を `terrafotm.tfvars` にリネームし、中身を適切な値に変更してください。

```
gcp_project_id = "<作成したGCPプロジェクトのid>"
primary_region = "<作成したGCPプロジェクトのリージョン>"
```

<br />

infra ディレクトリ内にある `[main.tf](http://main.tf)` 内の **app_name**, **frontend_app_name**, **github_owner**, **github_app_repo_name** をそれぞれ **アプリ名**, **フロントアプリ名**, **自身の GitHub アカウント名**, **事前に用意したリポジトリ名** に変更してください。

<br />

各 GCP リソースの API を有効にします。Cloud Build に関しては事前に用意したリポジトリと接続する必要があるため下のフローに従って接続してください。

- [Artifact Registry ページ](https://console.cloud.google.com/artifacts)に移動し、Artifact Registory API を有効化
- [Cloud Run ページ](https://console.cloud.google.com/run)に移動し、サービスの作成を押下し Cloud Run Admin API を有効化
- [Cloud Build ページ](https://console.cloud.google.com/cloud-build)に移動し、Cloud Build に移動し、Cloud Build API を有効化
  - 次のリンクから事前に用意した GitHub リポジトリと接続を行ってください。[https://console.cloud.google.com/cloud-build/repos;region=global](https://console.cloud.google.com/cloud-build/repos;region=global)

<br />

[IAM と管理 ページ](https://console.cloud.google.com/iam-admin/iam) から Cloud Build のサービスアカウントに下記のロールを付与してください。

- Cloud Run 管理者
- Cloud Run サービス エージェント

<br />

以上で GCP のリソースを作成する準備ができたので、下記のコマンドを順番に実行し 各 GCP リソースを作成しましょう。

```bash
cd infra
./tf.sh init
./tf.sh plan
./tf.sh apply
```

apply に成功すると main ブランチが進むと自動で Next.js アプリをデプロイする CD が構築されます。手動でデプロイしたい場合は [Cloud Build トリガー ページ](https://console.cloud.google.com/cloud-build/triggers)より **deploy-frontend の実行** を押下してください。
