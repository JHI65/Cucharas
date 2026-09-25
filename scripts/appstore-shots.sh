#!/bin/bash
# Captura screenshots del simulador iPhone 11 Pro Max a 1242x2688 (tamaño 6.5" de App Store Connect).
#
# Uso:
#   bash scripts/appstore-shots.sh          # captura una y sale
#   bash scripts/appstore-shots.sh watch    # captura cada vez que pulses Enter
#
# Las capturas se guardan numeradas en ~/Desktop/spoony-shots/

SIM_NAME="iPhone 11 Pro Max"
OUT="$HOME/Desktop/spoony-shots"
mkdir -p "$OUT"

SIM=$(xcrun simctl list devices | grep "$SIM_NAME (" | grep Booted | grep -oE '[0-9A-F-]{36}' | head -1)
if [ -z "$SIM" ]; then
  echo "No hay ningún '$SIM_NAME' arrancado."
  echo "Arráncalo con: xcrun simctl boot \"$SIM_NAME\" && open -a Simulator"
  exit 1
fi

shot() {
  N=$(ls "$OUT"/*.png 2>/dev/null | wc -l | tr -d ' ')
  F=$(printf "%s/%02d.png" "$OUT" $((N + 1)))
  xcrun simctl io "$SIM" screenshot "$F" >/dev/null 2>&1
  DIM=$(sips -g pixelWidth -g pixelHeight "$F" 2>/dev/null | awk '/pixel/{printf "%s ", $2}')
  echo "→ $F  (${DIM}px)"
}

if [ "$1" = "watch" ]; then
  echo "Simulador: $SIM"
  echo "Navega por la app y pulsa Enter para capturar. Ctrl+C para salir."
  while true; do
    read -r _
    shot
  done
else
  shot
fi
