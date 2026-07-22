# main.tf
terraform {
  required_version = ">= 1.0"
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "~> 1.0"
    }
  }
}

provider "alicloud" {
  region = "cn-shanghai"   # 按你的实际地域修改
  # AccessKey 不要硬编码，用环境变量：ALICLOUD_ACCESS_KEY / ALICLOUD_SECRET_KEY
}