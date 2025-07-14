#!/usr/bin/env dash

[ $# -eq 0 ] && {
    echo "Usage: $0 --title | --arturl | --artist | --length | --album | --source | --status"
    exit 1
}

get_metadata() {
    playerctl metadata --format "{{ $1 }}" 2>/dev/null
}

get_source_info() {
    trackid=$(get_metadata "mpris:trackid")
    case "$trackid" in
        *firefox*) echo "Firefox 󰈹" ;;
        *spotify*) echo "Spotify " ;;
        *chromium*) echo "Chrome " ;;
        *) echo "" ;;
    esac
}

case "$1" in
    --title)
        title=$(get_metadata "xesam:title")
        [ -n "$title" ] && echo "${title}" | cut -c1-28
        ;;
    --arturl)
        url=$(get_metadata "mpris:artUrl")
        [ -n "$url" ] && echo "${url#file://}"
        ;;
    --artist)
        artist=$(get_metadata "xesam:artist")
        [ -n "$artist" ] && echo "${artist}" | cut -c1-30
        ;;
    --length)
        length=$(get_metadata "mpris:length")
        if [ -n "$length" ]; then
            minutes=$(echo "scale=2; $length / 1000000 / 60" | bc)
            echo "$minutes m"
        fi
        ;;
    --status)
        status=$(playerctl status 2>/dev/null)
        case "$status" in
            Playing) echo "󰎆" ;;
            Paused) echo "󱑽" ;;
        esac
        ;;
    --album)
        album=$(get_metadata "xesam:album")
        if [ -n "$album" ]; then
            echo "$album"
        else
            status=$(playerctl status 2>/dev/null)
            [ -n "$status" ] && echo "Not album"
        fi
        ;;
    --source)
        get_source_info
        ;;
    *)
        echo "Invalid option: $1"
        exit 1
        ;;
esac
