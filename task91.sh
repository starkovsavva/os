#!/bin/bash

# Создаем тестовую среду
TEST_DIR="permission_lab"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR" || exit

# Создаем тестовые файлы
touch file.txt
mkdir test_folder
echo "Test content" > secret.txt
echo -e "#!/bin/bash\necho 'Hello from SUID script'" > suid_script.sh
chmod +x suid_script.sh

# Функция для отображения прав
show_permissions() {
    echo "Текущие права:"
    ls -l
    echo "--------------------------------"
}

# 9.1 Примеры chmod/chown
echo -e "\n[9.1] Примеры chmod и chown"
echo "Исходные права:"
show_permissions

# Меняем права числовым форматом
chmod 755 file.txt
echo "После chmod 755 file.txt:"
show_permissions

# Меняем права символьным форматом
chmod u=rwx,g=rx,o= test_folder
echo "После chmod u=rwx,g=rx,o= test_folder:"
show_permissions

# Меняем владельца (требует sudo)
sudo chown nobody file.txt 2>/dev/null
echo "После chown nobody file.txt:"
show_permissions

# 9.2 SUID флаг
echo -e "\n[9.2] Установка SUID"
sudo chmod 4755 suid_script.sh
echo "Права с SUID:"
ls -l suid_script.sh
echo "Проверка SUID:"
ls -l suid_script.sh | grep '^...s'

# 9.3 Разные права для пользователя и группы
echo -e "\n[9.3] Эксперимент с разными правами"
sudo useradd testuser -m -s /bin/bash 2>/dev/null
sudo groupadd testgroup 2>/dev/null
sudo usermod -aG testgroup testuser

# Создаем файл с разными правами
sudo touch special.txt
sudo chmod 750 special.txt
sudo chown testuser:testgroup special.txt
echo "Права special.txt:"
ls -l special.txt

# Проверяем доступ от разных пользователей
echo -e "\nПроверка доступа:"
echo "От владельца (testuser):"
sudo -u testuser bash -c "ls -l special.txt && cat special.txt 2>&1 | sed 's/^/  /'"

echo -e "\nОт члена группы (текущий пользователь):"
ls -l special.txt
cat special.txt 2>&1 | sed 's/^/  /'

# 9.4 Взаимодействие прав файла и каталога
echo -e "\n[9.4] Права каталога vs права файла"
mkdir dir_example
touch dir_example/inside.txt

echo -e "\nСлучай 1: Каталог rx, файл rw"
chmod 755 dir_example
chmod 600 dir_example/inside.txt
echo "Попытка чтения файла:"
cat dir_example/inside.txt 2>&1 | sed 's/^/  /'

echo -e "\nСлучай 2: Каталог --x, файл rw"
chmod 711 dir_example
echo "Попытка просмотра каталога:"
ls -l dir_example 2>&1 | sed 's/^/  /'
echo "Попытка чтения файла:"
cat dir_example/inside.txt 2>&1 | sed 's/^/  /'

# Уборка
cd ..
sudo rm -rf "$TEST_DIR"
sudo userdel testuser 2>/dev/null
sudo groupdel testgroup 2>/dev/null
echo -e "\nТестовая среда удалена. Все изменения отменены."