#cloud-config
# Создаем пользователя для администрирования ВМ
users:
  - name: ${ssh_user}            # Имя пользователя для входа по SSH
    groups: sudo                 # Добавляем в группу sudo
    shell: /bin/bash             # Стандартная оболочка
    sudo: ['ALL=(ALL) NOPASSWD:ALL']  # Разрешаем sudo без пароля
    ssh-authorized-keys:
      - ${ssh_public_key}        # Публичный SSH-ключ подставляется из Terraform переменной

# Обновление списка пакетов при первом старте
package_update: true

# Полный upgrade не обязателен, чтобы не удлинять первый boot
package_upgrade: false    