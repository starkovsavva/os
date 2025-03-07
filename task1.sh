#!/bin/bash

# Проверка количества аргументов
if [ $# -ne 1 ]; then
    echo "Использование: $0 <выходной_файл>"
    exit 1
fi

output_file="$1"
> "$output_file"  # Очистка выходного файла

# Функция для поиска файлов по типу
search_type() {
    local type="$1"
    local path="$2"
    
    # Используем ls -lR для рекурсивного поиска и awk для фильтрации
    ls -lR "$path" 2>/dev/null | awk -v type="$type" '
        $1 ~ "^"type {
            print $0 " " FILENAME "/" $NF;
            exit
        }
    ' | head -1 >> "$output_file"
}

# Основной поиск
search_type "-" /      # Обычные файлы
search_type "b" /dev   # Блочные устройства
search_type "c" /dev   # Символьные устройства
search_type "d" /      # Директории
search_type "l" /      # Симлинки
search_type "p" /      # FIFO (именованные каналы)
search_type "s" /      # Сокеты

echo "Результаты сохранены в: $output_file"