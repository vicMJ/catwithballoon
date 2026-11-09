#!/usr/bin/env bash
# Put this file in the server folder (next to the server jar) and start the server with it:
#   ./start-server.sh
# Every start it syncs mods from the pack on GitHub, then launches the server.
set -e
cd "$(dirname "$0")"

PACK_URL="https://raw.githubusercontent.com/vicMJ/catwithballoon/main/pack.toml"
SERVER_JAR="fabric-server-launch.jar"   # change to your server jar's name
RAM="6G"                                 # change to how much RAM the server should use

if [ ! -f packwiz-installer-bootstrap.jar ]; then
  curl -fsSL -o packwiz-installer-bootstrap.jar \
    https://github.com/packwiz/packwiz-installer-bootstrap/releases/latest/download/packwiz-installer-bootstrap.jar
fi

# -g = no GUI, -s server = skip client-only mods and shaders
if ! java -jar packwiz-installer-bootstrap.jar -g -s server "$PACK_URL"; then
  echo "Mod sync failed (GitHub down?) - starting with the mods already installed."
fi

exec java -Xms"$RAM" -Xmx"$RAM" -jar "$SERVER_JAR" nogui
