# ============================================
# 1. 声明 Terraform 核心配置与 Provider
# ============================================
terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      # 建议使用最新版本，但确保不低于 v1.143.0[reference:5]
      version = "~> 1.212"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

# 配置 Provider
provider "alicloud" {
  region = var.region
}

# ============================================
# 2. 定义变量（从 terraform.tfvars 读取）
# ============================================
variable "region" {
  description = "阿里云地域"
  type        = string
}

variable "real_server_ip" {
  description = "真实轻量应用服务器的公网IP"
  type        = string
}

# 新增变量，用于演示创建新实例
variable "instance_name" {
  description = "轻量应用服务器实例名"
  type        = string
  default     = "Ubuntu-ewlr"
}

variable "plan_id" {
  description = "轻量应用服务器套餐ID"
  type        = string
  default     = "swas.s2.c2m1s40b1t1"
}

variable "image_id" {
  description = "轻量应用服务器镜像ID"
  type        = string
  default     = "ubuntu_24_04"
}

# ============================================
# 3. 查询数据源 (用于获取镜像、套餐等信息)
# ============================================
# 查询可用的 Linux 镜像[reference:6]
data "alicloud_simple_application_server_images" "default" {
  platform = "Linux"
}

# 查询可用的套餐方案[reference:7]
data "alicloud_simple_application_server_plans" "default" {
  platform = "Linux"
}

# ============================================
# 4. (可选) 定义轻量应用服务器资源
# ============================================
# ?? 警告：取消下面注释将创建一台真实的、包年包月的轻量服务器，会产生费用！
# 如果只是演示与 Ansible 的联动，建议注释掉此资源块，仅使用 data 源查询已有资源。

# resource "alicloud_simple_application_server_instance" "default" {
#   # 计费方式：包年包月[reference:8]
#   payment_type = "Subscription"
#   # 套餐ID[reference:9]
#   plan_id = var.plan_id
#   # 镜像ID
#   image_id = var.image_id
#   # 实例名称
#   instance_name = var.instance_name
#   
#   # 数据盘大小 (GB)，可选
#   data_disk_size = 100
#   
#   # 购买时长 (月)，默认1个月
#   period = 1
# }

# ============================================
# 5. 自动生成 Ansible Inventory (核心联动)
# ============================================
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/ansible/inventory.ini"

  content = templatefile("${path.module}/ansible/inventory.tmpl", {
    # 这里直接使用 tfvars 中定义的 IP
    cloud_real_ip = var.real_server_ip
  })

  # 当IP变化时，自动更新 inventory.ini
}

output "inventory_generated" {
  value = "? Ansible inventory 已生成，轻量服务器 IP 为 ${var.real_server_ip}"
}

# 可选：输出查询到的镜像和套餐信息，供调试参考
output "available_images" {
  value = data.alicloud_simple_application_server_images.default.images
}

output "available_plans" {
  value = data.alicloud_simple_application_server_plans.default.plans
}