variable "region" { default = "ap-northeast-1" }

provider "aws" {
  profile = "aws_profile_name" // 自分が作成したawsのプロファイル名に置き換え
  region     = var.region
}

terraform {
  backend s3 {
    bucket  = "projectname-tfstate" // projectnameの部分を自分のプロジェクト名に置き換える
    key     = "terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
  }
}

module "base" {
  source = "./modules"
}