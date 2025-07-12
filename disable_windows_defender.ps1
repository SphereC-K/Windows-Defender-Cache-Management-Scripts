# Windows Defender Disable Script
# Run this script as Administrator

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script requires Administrator privileges. Please run as Administrator." -ForegroundColor Red
    Write-Host "Right-click on PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    pause
    exit
}

Write-Host "=== Windows Defender Disable Script ===" -ForegroundColor Cyan
Write-Host "WARNING: Disabling Windows Defender may leave your system vulnerable to malware!" -ForegroundColor Red
Write-Host ""

$confirm = Read-Host "Are you sure you want to disable Windows Defender? (y/N)"
if ($confirm -ne "y" -and $confirm -ne "Y") {
    Write-Host "Operation cancelled." -ForegroundColor Yellow
    pause
    exit
}

try {
    Write-Host "Disabling Windows Defender..." -ForegroundColor Yellow
    
    # Disable Windows Defender Real-time protection
    Set-MpPreference -DisableRealtimeMonitoring $true
    Write-Host "✓ Real-time monitoring disabled" -ForegroundColor Green
    
    # Disable Windows Defender
    Set-MpPreference -DisableIOAVProtection $true
    Write-Host "✓ IOAV Protection disabled" -ForegroundColor Green
    
    # Disable Windows Defender behavior monitoring
    Set-MpPreference -DisableBehaviorMonitoring $true
    Write-Host "✓ Behavior monitoring disabled" -ForegroundColor Green
    
    # Disable Windows Defender block at first sight
    Set-MpPreference -DisableBlockAtFirstSeen $true
    Write-Host "✓ Block at first sight disabled" -ForegroundColor Green
    
    # Disable Windows Defender cloud protection
    Set-MpPreference -MAPSReporting Disabled
    Write-Host "✓ Cloud protection disabled" -ForegroundColor Green
    
    # Disable Windows Defender sample submission
    Set-MpPreference -SubmitSamplesConsent NeverSend
    Write-Host "✓ Sample submission disabled" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "Windows Defender has been disabled successfully!" -ForegroundColor Green
    Write-Host "Remember to re-enable it later for security." -ForegroundColor Yellow
    
} catch {
    Write-Host "Error occurred: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Make sure you're running as Administrator and Windows Defender is not being managed by Group Policy." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 