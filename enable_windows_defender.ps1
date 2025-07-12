# Windows Defender Enable Script
# Run this script as Administrator

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script requires Administrator privileges. Please run as Administrator." -ForegroundColor Red
    Write-Host "Right-click on PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    pause
    exit
}

Write-Host "=== Windows Defender Enable Script ===" -ForegroundColor Cyan
Write-Host ""

$confirm = Read-Host "Do you want to re-enable Windows Defender? (y/N)"
if ($confirm -ne "y" -and $confirm -ne "Y") {
    Write-Host "Operation cancelled." -ForegroundColor Yellow
    pause
    exit
}

try {
    Write-Host "Re-enabling Windows Defender..." -ForegroundColor Yellow
    
    # Enable Windows Defender Real-time protection
    Set-MpPreference -DisableRealtimeMonitoring $false
    Write-Host "✓ Real-time monitoring enabled" -ForegroundColor Green
    
    # Enable Windows Defender
    Set-MpPreference -DisableIOAVProtection $false
    Write-Host "✓ IOAV Protection enabled" -ForegroundColor Green
    
    # Enable Windows Defender behavior monitoring
    Set-MpPreference -DisableBehaviorMonitoring $false
    Write-Host "✓ Behavior monitoring enabled" -ForegroundColor Green
    
    # Enable Windows Defender block at first sight
    Set-MpPreference -DisableBlockAtFirstSeen $false
    Write-Host "✓ Block at first sight enabled" -ForegroundColor Green
    
    # Enable Windows Defender cloud protection
    Set-MpPreference -MAPSReporting Advanced
    Write-Host "✓ Cloud protection enabled" -ForegroundColor Green
    
    # Enable Windows Defender sample submission
    Set-MpPreference -SubmitSamplesConsent SendSafeSamples
    Write-Host "✓ Sample submission enabled" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "Windows Defender has been re-enabled successfully!" -ForegroundColor Green
    Write-Host "Your system is now protected again." -ForegroundColor Green
    
} catch {
    Write-Host "Error occurred: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Make sure you're running as Administrator." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 