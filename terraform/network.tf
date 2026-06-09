#network.tf

# Создаем VPC-сеть для проекта
resource "yandex_vpc_network" "develop" {
  name = "develop-fops-${var.flow}"
}

# Создаем NAT gateway для исходящего доступа в интернет
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "fops-gateway-${var.flow}"
  shared_egress_gateway {}
}

# Создаем таблицу маршрутов и отправляем весь внешний трафик через NAT gateway
resource "yandex_vpc_route_table" "rt" {
  name       = "fops-route-table-${var.flow}"
  network_id = yandex_vpc_network.develop.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

# Единственная подсеть в той же зоне, где будет ВМ
resource "yandex_vpc_subnet" "develop_a" {
  name           = "develop-fops-${var.flow}-ru-central1-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.1.0/24"]
  route_table_id = yandex_vpc_route_table.rt.id
}

# Security group для доступа к ВМ и приложению
resource "yandex_vpc_security_group" "ha_cluster" {
  name       = "ha-cluster-${var.flow}"
  network_id = yandex_vpc_network.develop.id

  ingress {
    description    = "SSH"
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 22
    to_port        = 22
  }

  egress {
    description    = "ANY outbound"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Выводим ID security group
output "security_group_id" {
  value = yandex_vpc_security_group.ha_cluster.id
}

# Выводим ID единственной используемой подсети
output "subnet_a" {
  value = yandex_vpc_subnet.develop_a.id
}