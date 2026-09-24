#!/bin/bash

DIR_WALLPAPERS="$HOME/Pictures/Wallpapers"
LINK_HYPRLOCK="$HOME/.cache/current_wallpaper"

if [ ! -d "$DIR_WALLPAPERS" ]; then
    echo "Directory not found: $DIR_WALLPAPERS"
    exit 1
fi

ROFI_THEME="
window {
    location: center;
    anchor: center; 
    width: 70%; 
    height: 45%; 
    border-radius: 8px; 
    border: 1px solid;
    padding: 14px;
}

mainbox {
    background-color: transparent;
    children: [ \"inputbar\", \"listview\" ];
    spacing: 12px;
}

inputbar {
    spacing: 4px;
    background-color: rgba(255, 255, 255, 0.04);
    text-color: #ffffff;
    border-radius: 8px;
    children: [ \"prompt\", \"entry\" ];
    padding: 8px 18px;
}

prompt {
    background-color: transparent;
    text-color: #ffffff;
    vertical-align: 0.5;
}

entry {
    background-color: transparent;
    text-color: #ffffff;
    placeholder: \"Search wallpapers...\";
    placeholder-color: rgba(255, 255, 255, 0.4);
    vertical-align: 0.5;
}

listview { 
    columns: 4; 
    lines: 3; 
    spacing: 10px; 
    fixed-columns: true;
    fixed-height: true;
    background-color: transparent;
}

element { 
    orientation: vertical; 
    padding: 1px 6px; 
    border-radius: 4px; 
    background-color: transparent;
    children: [ \"element-icon\" ];
}

element selected.normal {
    background-color: #FFFFFFFF;
    text-color: #000000FF;
}

element-icon { 
    size: 220px; 
    horizontal-align: 0.5; 
    vertical-align: 0.5;
    background-color: transparent;
}

element-text { 
    enabled: false; 
}
"

CHOICE=$(for img in "$DIR_WALLPAPERS"/*.{jpg,jpeg,png,webp}; do
    [ -e "$img" ] || continue 
    name=$(basename "$img")
    echo -e "${name}\0icon\x1f${img}"
done | rofi -dmenu -i -show-icons -p " " -theme-str "$ROFI_THEME")

if [ -n "$CHOICE" ]; then
    FULL_PATH="$DIR_WALLPAPERS/$CHOICE"
    ln -sf "$FULL_PATH" "$LINK_HYPRLOCK"

    awww img "$FULL_PATH" \
        --transition-fps 144 \
        --transition-type any \
        --transition-angle 30 \
        --transition-step 90
fi
