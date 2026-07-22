# 你的轻量应用服务器所在地域
region = "cn-shanghai"

# ? 请替换为你的轻量应用服务器的公网IP
real_server_ip = "101.133.236.64"

# ? (可选) 如果你想在演示中创建一个新的轻量服务器，请填写以下信息
# 注意：这会产生费用！如果只是演示，建议注释掉 resource 块，仅用 data 源。
#instance_name = "tf-sas-demo"
# 套餐规格ID，可通过数据源 alicloud_simple_application_server_plans 查询
#plan_id = "swas.s2.c2m1s40b1t1" 
# 镜像ID，可通过数据源 alicloud_simple_application_server_images 查询
#image_id = "ubuntu_20_04" 