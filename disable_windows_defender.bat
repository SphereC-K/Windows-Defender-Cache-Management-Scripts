@echo off
title Windows Defender Disable Script
color 0A

echo ========================================
echo    Windows Defender Disable Script
echo ========================================
echo.
echo WARNING: This will disable Windows Defender
echo This may leave your system vulnerable to malware!
echo.
echo Make sure you understand the risks before proceeding.
echo.

set /p confirm="Do you want to continue? (y/N): "
if /i not "%confirm%"=="y" (
    echo Operation cancelled.
    pause
    exit /b
)

echo.
echo Running PowerShell script with Administrator privileges...
echo.

powershell -ExecutionPolicy Bypass -File "%~dp0disable_windows_defender.ps1"

echo.
echo Script completed.
pause 