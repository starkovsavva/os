# Проверка наличия аргумента
if [ $# -ne 1 ]; then
    echo "Usage: $0 <file>"
    exit 1
fi

# Имя файла для поиска
target_file="$1"

# Файл для сохранения результатов
output_file="out.txt"

# Очистка файла с результатами
> "$output_file"

# Поиск символьных ссылок, указывающих на целевой файл
ls -lR / 2>/dev/null | grep $1 | grep ^l | awk '{print $0}' > "$output_file"

# Подсчет количества найденных ссылок
count=$(wc -l < "$output_file")

# Добавление количества ссылок в файл
echo "total $count" >> "$output_file"

# Вывод результата
echo "Результаты сохранены в $output_file"
echo "Найдено ссылок: $count"