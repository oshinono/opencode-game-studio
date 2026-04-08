#!/bin/bash

# Скрипт для смены модели в файлах .opencode/agents/*.md и .opencode/opencode.json
# Использование: ./change_model.sh "новая-модель"

set -e

# Проверка аргументов
if [ $# -eq 0 ]; then
    echo "Использование: ./change_model.sh \"<новая-модель>\""
    echo ""
    echo "Примеры:"
    echo "  ./change_model.sh \"opencode/big-pickle\""
    echo "  ./change_model.sh \"arcee-ai/trinity-large-preview:free\""
    echo "  ./change_model.sh \"gpt-4-turbo\""
    exit 1
fi

NEW_MODEL="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_DIR="${SCRIPT_DIR}/.opencode/agents"
CONFIG_FILE="${SCRIPT_DIR}/.opencode/opencode.json"

echo "🔄 Смена модели на: $NEW_MODEL"
echo ""

# Функция для безопасного изменения значения model в JSON
# Работает как с моделями "namespace/model", так и с другими форматами
update_json_model() {
    local file="$1"
    local temp_file="${file}.tmp"
    
    # Используем sed для замены значения model в JSON
    # Ключ слова: найти "model": "<любое значение>" и заменить на "model": "<новое значение>"
    # Используем | как разделитель вместо / чтобы избежать конфликтов с косыми чертами в моделях
    sed -E 's|"model": "[^"]*"|"model": "'"$NEW_MODEL"'"|g' "$file" > "$temp_file"
    
    if [ -s "$temp_file" ]; then
        mv "$temp_file" "$file"
        return 0
    else
        rm "$temp_file"
        return 1
    fi
}

# Функция для изменения model в YAML frontmatter markdown файлов
update_markdown_model() {
    local file="$1"
    local temp_file="${file}.tmp"
    
    # Замена model: <старое значение> на model: <новое значение>
    # Учитываем, что может быть с кавычками или без
    # Используем | как разделитель вместо / чтобы избежать конфликтов с косыми чертами в моделях
    sed -E 's|^model: .*$|model: '"$NEW_MODEL"'|' "$file" > "$temp_file"
    
    if [ -s "$temp_file" ]; then
        mv "$temp_file" "$file"
        return 0
    else
        rm "$temp_file"
        return 1
    fi
}

# Счётчик обновлённых файлов
updated_agents=0
updated_json=0

# Обновление файлов agents/*.md
if [ -d "$AGENTS_DIR" ]; then
    echo "📝 Обновление .opencode/agents/*.md..."
    for agent_file in "$AGENTS_DIR"/*.md; do
        if [ -f "$agent_file" ]; then
            # Проверяем наличие model: в файле
            if grep -q "^model:" "$agent_file"; then
                update_markdown_model "$agent_file"
                agent_name=$(basename "$agent_file")
                echo "  ✓ $agent_name"
                ((updated_agents++))
            fi
        fi
    done
fi

echo ""

# Обновление opencode.json
if [ -f "$CONFIG_FILE" ]; then
    echo "⚙️  Обновление .opencode/opencode.json..."
    
    # Подсчёт и вывод информации
    model_count=$(grep -c '"model":' "$CONFIG_FILE" || true)
    
    if [ "$model_count" -gt 0 ]; then
        update_json_model "$CONFIG_FILE"
        echo "  ✓ Обновлено $model_count записей в opencode.json"
        updated_json=$model_count
    fi
else
    echo "⚠️  Файл $CONFIG_FILE не найден"
fi

echo ""
echo "✅ Завершено!"
echo "   • Агентов обновлено: $updated_agents"
echo "   • Записей в opencode.json обновлено: $updated_json"
echo "   • Новая модель: $NEW_MODEL"
