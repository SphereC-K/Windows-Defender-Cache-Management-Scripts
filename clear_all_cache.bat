@echo off
title Clear All Cache - Windows System
color 0B

echo ========================================
echo      Clear All Cache - Windows
echo ========================================
echo.
echo This script will clear all types of cache:
echo - Windows Update Cache
echo - DNS Cache
echo - Temporary Files
echo - Browser Cache (Chrome, Firefox, Edge)
echo - Windows Store Cache
echo - System Cache
echo - User Profile Cache
echo.

set /p confirm="Do you want to continue? (y/N): "
if /i not "%confirm%"=="y" (
    echo Operation cancelled.
    pause
    exit /b
)

echo.
echo Starting cache cleanup process...
echo.

:: Check for Administrator privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    echo ✓ Running with Administrator privileges
) else (
    echo ✗ This script requires Administrator privileges
    echo Please right-click and select "Run as Administrator"
    pause
    exit /b
)

echo.
echo ========================================
echo Clearing Windows Update Cache...
echo ========================================
net stop wuauserv
net stop bits
net stop cryptsvc
echo Stopping Windows Update services...

if exist "%SystemRoot%\SoftwareDistribution\Download" (
    rmdir /s /q "%SystemRoot%\SoftwareDistribution\Download"
    echo ✓ Windows Update cache cleared
) else (
    echo - Windows Update cache folder not found
)

if exist "%SystemRoot%\SoftwareDistribution\ReportingEvents.log" (
    del /f /q "%SystemRoot%\SoftwareDistribution\ReportingEvents.log"
    echo ✓ Windows Update log cleared
)

net start wuauserv
net start bits
net start cryptsvc
echo ✓ Windows Update services restarted

echo.
echo ========================================
echo Clearing DNS Cache...
echo ========================================
ipconfig /flushdns
echo ✓ DNS cache flushed

echo.
echo ========================================
echo Clearing Temporary Files...
echo ========================================
if exist "%TEMP%" (
    rmdir /s /q "%TEMP%"
    mkdir "%TEMP%"
    echo ✓ User temp files cleared
)

if exist "%SystemRoot%\Temp" (
    rmdir /s /q "%SystemRoot%\Temp"
    mkdir "%SystemRoot%\Temp"
    echo ✓ System temp files cleared
)

echo.
echo ========================================
echo Clearing Windows Store Cache...
echo ========================================
if exist "%LOCALAPPDATA%\Packages\Microsoft.WindowsStore_*\LocalCache" (
    rmdir /s /q "%LOCALAPPDATA%\Packages\Microsoft.WindowsStore_*\LocalCache"
    echo ✓ Windows Store cache cleared
)

if exist "%LOCALAPPDATA%\Packages\Microsoft.WindowsStore_*\LocalState" (
    rmdir /s /q "%LOCALAPPDATA%\Packages\Microsoft.WindowsStore_*\LocalState"
    echo ✓ Windows Store state cleared
)

echo.
echo ========================================
echo Clearing System Cache...
echo ========================================
if exist "%SystemRoot%\Prefetch" (
    rmdir /s /q "%SystemRoot%\Prefetch"
    mkdir "%SystemRoot%\Prefetch"
    echo ✓ Prefetch cache cleared
)

if exist "%SystemRoot%\System32\winevt\Logs" (
    del /f /q "%SystemRoot%\System32\winevt\Logs\*.evtx"
    echo ✓ Event logs cleared
)

echo.
echo ========================================
echo Clearing Browser Cache...
echo ========================================

:: Chrome Cache
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache" (
    rmdir /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache"
    echo ✓ Chrome cache cleared
)

if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Code Cache" (
    rmdir /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Code Cache"
    echo ✓ Chrome code cache cleared
)

:: Firefox Cache
if exist "%APPDATA%\Mozilla\Firefox\Profiles" (
    for /d %%i in ("%APPDATA%\Mozilla\Firefox\Profiles\*") do (
        if exist "%%i\cache2" (
            rmdir /s /q "%%i\cache2"
        )
        if exist "%%i\cache" (
            rmdir /s /q "%%i\cache"
        )
    )
    echo ✓ Firefox cache cleared
)

:: Edge Cache
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache"
    echo ✓ Edge cache cleared
)

if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache" (
    rmdir /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache"
    echo ✓ Edge code cache cleared
)

echo.
echo ========================================
echo Clearing User Profile Cache...
echo ========================================
if exist "%APPDATA%\Microsoft\Windows\Recent" (
    rmdir /s /q "%APPDATA%\Microsoft\Windows\Recent"
    mkdir "%APPDATA%\Microsoft\Windows\Recent"
    echo ✓ Recent files cache cleared
)

if exist "%APPDATA%\Microsoft\Windows\Explorer" (
    del /f /q "%APPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db"
    echo ✓ Thumbnail cache cleared
)

echo.
echo ========================================
echo Running Disk Cleanup...
echo ========================================
cleanmgr /sagerun:1
echo ✓ Disk cleanup completed

echo.
echo ========================================
echo Cache Cleanup Complete!
echo ========================================
echo.
echo All cache has been cleared successfully.
echo You may need to restart your computer for all changes to take effect.
echo.
echo Press any key to exit...
pause >nul 