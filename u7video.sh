#!/bin/bash

VERSION="2.1"
SERVER_NICKNAME="robert"
SERVER_PATH="/home/web/u7tv.ru/www/video"

MSG_INVALID_FILENAME="Invalid filename format: must be 4 digits followed by .mp4"
MSG_MISSING_FILENAME="Missing filename"
MSG_MISSING_FILES="Missing files for upload"
MSG_MISSING_SERVER_NICKNAME="Missing server nickname information"
MSG_HELP="Usage: u7video [option] <filename>
Options:
  mp4       Create a compressed MP4 version
  webm      Create a compressed WebM version
  both      Create both MP4 and WebM versions
  upload    Upload compressed videos to the server
  version   Show version information
  help      Display this help message
If no option is specified, both conversion and upload will be performed."
MSG_VERSION="u7video version $VERSION"

validate_filename() {
    if [[ ! "$1" =~ ^[0-9]{4}\.mp4$ ]]; then
        echo "$MSG_INVALID_FILENAME"
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
        echo "$MSG_MISSING_FILES"
        exit 1
    fi

    if [[ -z "$SERVER_NICKNAME" ]]; then
        echo "$MSG_MISSING_SERVER_NICKNAME"
        exit 1
    fi

    scp "${base_name}.min.mp4" "${SERVER_NICKNAME}:${SERVER_PATH}/${base_name}.mp4"
    scp "${base_name}.min.webm" "${SERVER_NICKNAME}:${SERVER_PATH}/${base_name}.webm"
}

show_help() {
    echo "$MSG_HELP"
}

if [[ "$1" == "" || "$1" == "help" ]]; then
    show_help
    exit 0
elif [[ "$1" == "version" ]]; then
    echo "$MSG_VERSION"
    exit 0
fi

if [[ -z "$2" ]]; then
    if [[ "$1" =~ ^(mp4|webm|both|upload)$ ]]; then
        echo "$MSG_MISSING_FILENAME"
        exit 1
    fi
    ACTION="both-upload"
    FILE="$1"
else
    ACTION="$1"
    FILE="$2"
fi

if [[ "$ACTION" != "version" && "$ACTION" != "help" ]]; then
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
        both-upload)
            process_mp4 "$FILE"
            process_webm "$FILE"
            upload_files "$FILE"
            ;;
        *)
            process_mp4 "$FILE"
            process_webm "$FILE"
            upload_files "$FILE"
            ;;
    esac
fi
