#!/bin/bash

VERSION="2.0"
SERVER_USER="web"
SERVER_ADDRESS="213.189.220.204"
SERVER_PATH="/home/web/u7tv.ru/www/video"

validate_filename() {
    if [[ ! "$1" =~ ^[0-9]{4}\.mp4$ ]]; then
        echo "Неверное имя исходного файла"
        exit 1
    fi
}

process_mp4() {
    ffmpeg -i "$1" -b:v 7M "${1%.mp4}.min.mp4"
}

process_webm() {
    ffmpeg -i "$1" -c:v libvpx -crf 10 -b:v 7M -c:a libvorbis "${1%.mp4}.min.webm"
}

upload_files() {
    local base_name="${1%.mp4}"
    
    if [[ ! -f "${base_name}.min.mp4" || ! -f "${base_name}.min.webm" ]]; then
        echo "Отсутствуют файлы для загрузки"
        exit 1
    fi

    scp "${base_name}.min.mp4" "${SERVER_USER}@${SERVER_ADDRESS}:${SERVER_PATH}/${base_name}.mp4"
    scp "${base_name}.min.webm" "${SERVER_USER}@${SERVER_ADDRESS}:${SERVER_PATH}/${base_name}.webm"
}

show_help() {
    cat << EOF
Использование: u7video [ключ] <имя_файла>
Ключи:
  mp4       Создать сжатую MP4-версию видео
  webm      Создать сжатую WebM-версию видео
  both      Создать обе версии видео
  upload    Загрузить сжатые версии видео на сервер
  version   Информация о версии
  help      Показать эту справку
Если ключи не указаны, выполняются действия both и upload.
EOF
}

# Основная логика
if [[ "$1" == "" || "$1" == "help" ]]; then
    show_help
    exit 0
elif [[ "$1" == "version" ]]; then
    echo "u7video version $VERSION"
    exit 0
fi

ACTION="$1"
FILE="$2"

if [[ "$ACTION" != "version" && "$ACTION" != "help" ]]; then
    if [[ -z "$FILE" ]]; then
        echo "Ошибка: укажите имя файла."
        exit 1
    fi

    validate_filename "$FILE"

    case "$ACTION" in
        mp4)
            process_mp4 "$FILE"
            ;;
        webm)
            process_webm "$FILE"
            ;;
        both)
            process_mp4 "$FILE"
            process_webm "$FILE"
            ;;
        upload)
            upload_files "$FILE"
            ;;
        *)
            process_mp4 "$FILE"
            process_webm "$FILE"
            upload_files "$FILE"
            ;;
    esac
fi
