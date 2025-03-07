#!/bin/bash

# 1. Проверка прав доступа к файлам
echo "=== Права доступа ==="
ls -l /etc/passwd /etc/shadow /usr/bin/passwd

# 2. Просмотр содержимого /etc/passwd (первые 3 строки)
echo -e "\n=== /etc/passwd (первые 3 строки) ==="
head -n 3 /etc/passwd

# 3. Попытка чтения /etc/shadow без прав
echo -e "\n=== Попытка чтения /etc/shadow ==="
cat /etc/shadow 2>&1 | head -n 3

# 4. Чтение /etc/shadow с правами root
echo -e "\n=== /etc/shadow через sudo (первые 3 строки) ==="
sudo cat /etc/shadow 2>/dev/null | head -n 3

# 5. Демонстрация работы /usr/bin/passwd
echo -e "\n=== Изменение пароля (нажмите Ctrl+C чтобы отменить) ==="
passwd