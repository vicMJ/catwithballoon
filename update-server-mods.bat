@echo off
echo Updates the server-only mods to their newest versions, then pushes.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0sync-from-launcher.ps1" -UpdateServerMods %*
pause
