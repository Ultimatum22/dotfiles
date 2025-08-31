#!/bin/bash

icon_volume_high="audio-volume-high"
icon_volume_low="audio-volume-low"
icon_volume_muted="audio-volume-muted"
icon_mic_muted="microphone-sensitivity-muted"
icon_mic="microphone-sensitivity-high"

case "$1" in
  up)
    pactl set-sink-volume @DEFAULT_SINK@ +5%
    vol=$(pactl get-sink-volume @DEFAULT_SINK@ | awk 'NR==1{print $5}')
    notify-send -r 99991 -a "Volume" -i "$icon_volume_high" -u normal "Volume ↑" "$vol"
    ;;
  down)
    pactl set-sink-volume @DEFAULT_SINK@ -5%
    vol=$(pactl get-sink-volume @DEFAULT_SINK@ | awk 'NR==1{print $5}')
    notify-send -r 99992 -a "Volume" -i "$icon_volume_low" -u normal "Volume ↓" "$vol"
    ;;
  mute)
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    state=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
    if [[ "$state" == "yes" ]]; then
      notify-send -r 99993 -a "Volume" -i "$icon_volume_muted" -u critical "Muted"
    else
      vol=$(pactl get-sink-volume @DEFAULT_SINK@ | awk 'NR==1{print $5}')
      notify-send -r 99993 -a "Volume" -i "$icon_volume_high" -u normal "Unmuted" "$vol"
    fi
    ;;
  mic)
    pactl set-source-mute @DEFAULT_SOURCE@ toggle
    state=$(pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}')
    if [[ "$state" == "yes" ]]; then
      notify-send -r 99994 -a "Microphone" -i "$icon_mic_muted" -u critical "Mic Muted"
    else
      notify-send -4 99994 -a "Microphone" -i "$icon_mic" -u normal "Mic Active"
    fi
    ;;
esac
