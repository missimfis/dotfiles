#!/usr/bin/env zsh

# record webcam and open it in sdl window
ffmpeg -v quiet -hide_banner \
  -re -video_size 640X480 -hwaccel vaapi -vaapi_device /dev/dri/renderD128 -i /dev/video0 \
  -vf 'format=nv12,hwupload' -c:v hevc_vaapi -f hevc - \
  | ffmpeg -v quiet -i - -f sdl2 - &

# wait for webcam window to open
until swaymsg -t get_tree | grep 'pipe:' &>/dev/null; do
  sleep 0.5
done

# position webcam in the bottom right corner of screen using sway
swaymsg floating enable
swaymsg resize set width 320 height 240
swaymsg move position 1580 795
swaymsg focus tiling

#screencast
ffmpeg -format bgra -framerate 60 -f kmsgrab -thread_queue_size 1024 -i - \
  -f alsa -ac 2 -thread_queue_size 1024 -i hw:0 \
  -vf 'hwmap=derive_device=vaapi,scale_vaapi=w=1920:h=1080:format=nv12' \
  -c:v h264_vaapi -g 120 -b:v 3M -maxrate 3M -pix_fmt vaapi_vld -c:a aac -ab 96k -threads $(nproc) \
  output.mkv

kill %1
