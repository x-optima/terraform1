#!/bin/bash

#deploy.sh

# -e  -> остановить скрипт при любой ошибке команды
# -u  -> считать ошибкой обращение к несуществующей переменной
# pipefail -> если в пайпе упала любая команда, считать весь пайп ошибкой
set -euo pipefail

cd "$(dirname "$0")/terraform"

terraform init

# Первый apply создаём только ВМ и локальный inventory для Ansible.
# так как docker provider не сможет работать пока ВМ ещё не существует и на ней не установлен docker
terraform apply -auto-approve -target=yandex_compute_instance.server1 -target=local_file.inventory

# Получаем внешний IP ВМ из Terraform output. Используем для ожидания SSH
IP=$(terraform output -raw external_ip)

echo "Waiting for SSH on ${IP}:22 ..."

# Ждём, пока на ВМ откроется 22-й порт.
for i in {1..60}; do
  if nc -z "$IP" 22 2>/dev/null; then
    echo "SSH is reachable on ${IP}:22"
    break
  fi

  echo "Still waiting for SSH... attempt ${i}/60"
  sleep 5
done

ansible-playbook -i hosts.ini playbook1.yml

# Второй полный apply.Docker на ВМ уже установлен и Terraform сможет через docker provider по SSH mysql:8 и контейнер
terraform apply -auto-approve