#!/bin/bash

# Конфигурация (обновите пути!)
SECRET_FILE="secret.txt"    # Абсолютный путь
GATEWAY_PROGRAM="gateway"  # Абсолютный путь
TEST_USER="tester"

# Проверка зависимостей
check_dependencies() {
    [ -f "$SECRET_FILE" ] || { echo "Файл $SECRET_FILE не найден"; exit 1; }
    [ -f "$GATEWAY_PROGRAM" ] || { echo "Программа $GATEWAY_PROGRAM не найдена"; exit 1; }
}

# Настройка окружения
setup_environment() {
    echo -e "\n[1] Настройка:"
    
    # Явно устанавливаем права
    sudo chown root:root "$GATEWAY_PROGRAM"
    sudo chmod 4755 "$GATEWAY_PROGRAM"
    echo "Программа: $(ls -l $GATEWAY_PROGRAM)"
    
    sudo chmod 600 "$SECRET_FILE"
    sudo chown root:root "$SECRET_FILE"
    echo "Файл: $(ls -l $SECRET_FILE)"
    
    # Создаем пользователя с домашней директорией
    sudo useradd -m -s /bin/bash "$TEST_USER" 2>/dev/null
}

# Проведение тестов
run_tests() {
    echo -e "\n[2] Тесты:"
    
    # Тест 1: Запуск программы
    echo -e "\nТест 1: Запуск шлюза"
    sudo -u "$TEST_USER" "$GATEWAY_PROGRAM" "$SECRET_FILE"
    
    # Тест 2: Прямой доступ
    echo -e "\nТест 2: Прямое чтение"
    sudo -u "$TEST_USER" cat "$SECRET_FILE" 2>&1 | sed 's/^/  /'
}

# Очистка
cleanup() {
    echo -e "\n[3] Восстановление:"
    sudo chmod 755 "$GATEWAY_PROGRAM"
    sudo chmod 644 "$SECRET_FILE"
    sudo userdel -r "$TEST_USER" 2>/dev/null
}

main() {
    check_dependencies
    setup_environment
    run_tests
    cleanup
}

main