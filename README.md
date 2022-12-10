# 構築フロー

- GCP でプロジェクトを作成する https://console.cloud.google.com/projectcreate

- 作成したプロジェクトの config を作成する

```bash
gcloud config configurations create <プロジェクトid>
```

また、下記コマンドでアクティブになっている config の確認、指定 config のアクティブ化ができる

```bash
# アクティブになっている config の確認
gcloud config configurations list
# 指定 config のアクティブ化
gcloud config configurations activate <config名>
```

- 作成した config に プロジェクト id, email などのメタ情報を紐づける

```bash
gcloud config set core/account <メールアドレス>
gcloud config set core/project <プロジェクトid>
```

- ログインを行う

```bash
gcloud auth login
```

- 認証処理を行う

```bash
gcloud auth application-default login
```

- 下記コマンドを実行し Cloud Storage バケットを作成する

```bash
gsutil mb -l asia-northeast1 gs://<任意のバケット名(スネークケース推奨)>
```

バケット名が重複している場合 `BadRequestException: 400 The specified location constraint is not valid.` となりバケットの作成ができないので、その場合は別の名前で作成する。

- infra/tf.sh に実行権限を付与

```bash
chmod +x infra/tf.sh
```

- 作成したバケット上で terraform リソースを作成する

```bash
cd infra
./tf.sh init -backend-config="bucket=<作成したバケット名>"
# ex. ./tf.sh init -backend-config="bucket=nextjs_gcp_starter_kit"
```

実行に成功すると、gs://<作成したバケット名>/tfstate/v1 に状態管理ファイルである default.tfstate が生成される。

- terraform.tfvars を作成する

terraform.tfvars.sample を terrafotm.tfvars にリネームし、中身を適当に変更する。

- infra/modules/artifact-registory/artifact-registory.tf を適切な値に変更 <アプリ名> → hoge_app

- main.tf 内を適切な値に変更 <アプリ名> → hoge_app

- GitHub のリポジトリを作成し、CloudBuild と接続を行う

GitHub のリポジトリを作成

https://console.cloud.google.com/marketplace/product/google/cloudbuild.googleapis.com より Cloud BUild API を有効にする

https://console.cloud.google.com/cloud-build/repos;region=global よりリポジトリを接続する。

- 各 GCP の API を有効にし、下記コマンドを実行し 各 GCP リソースを作成する

[Artifact Registry ページ](https://console.cloud.google.com/artifacts)に移動し、Artifact Registory API を有効にする
[Cloud Build ページ](https://console.cloud.google.com/cloud-build)に移動し、Cloud Build に移動し、Cloud Build API を有効にする
[Cloud Run ページ](https://console.cloud.google.com/run)に移動し、サービスの作成を押下し Cloud Run Admin API を有効にする

```bash
cd infra
./tf.sh init
./tf.sh plan
./tf.sh apply
```
