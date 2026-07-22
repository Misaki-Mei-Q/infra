provider "alicloud" { region = "cn-shanghai" }
resource "alicloud_instance" "demo" {
  # 先用 import 导入现有实例
}
resource "alicloud_security_group_rule" "allow_grafana" {
  type        = "ingress"
  ip_protocol = "tcp"
  port_range  = "3000/3000"
  security_group_id = alicloud_security_group.demo.id
  cidr_ip     = "0.0.0.0/0"
}