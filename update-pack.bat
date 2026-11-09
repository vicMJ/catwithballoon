@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0sync-from-launcher.ps1" %*
pause
