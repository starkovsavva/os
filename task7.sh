#!/bin/bash

# Создаем новый каталог
mkdir test_dir
echo "Создан каталог: test_dir"

# Функция для вывода размера каталога
show_size() {
    echo "Текущий размер каталога: $(du -sh test_dir | awk '{print $1}')"
}

# Шаг 1: Начальный размер каталога
echo "=== Начальный размер ==="
show_size
echo ""

# Шаг 2: Добавляем 5 файлов по 1 МБ
echo "=== Добавляем 5 файлов по 1 МБ ==="
for i in {1..5}; do
    dd if=/dev/urandom of=test_dir/file_$i bs=1M count=1 status=none
done
show_size
echo ""

# Шаг 3: Удаляем 3 файла
echo "=== Удаляем 3 файла ==="
rm test_dir/file_{1..3}
show_size
echo ""

# Шаг 4: Добавляем 100 пустых файлов
echo "=== Добавляем 100 пустых файлов ==="
touch test_dir/empty_file_{1..100}
show_size
echo ""

# Шаг 5: Очищаем каталог
echo "=== Очищаем каталог ==="
rm -rf test_dir/*
show_size

# Удаляем каталог
rm -rf test_dir