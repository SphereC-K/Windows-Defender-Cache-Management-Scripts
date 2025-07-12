# Clear All Cache - Windows System
# Run this script as Administrator

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script requires Administrator privileges. Please run as Administrator." -ForegroundColor Red
    Write-Host "Right-click on PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    pause
    exit
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "      Clear All Cache - Windows" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This script will clear all types of cache:" -ForegroundColor White
Write-Host "- Windows Update Cache" -ForegroundColor White
Write-Host "- DNS Cache" -ForegroundColor White
Write-Host "- Temporary Files" -ForegroundColor White
Write-Host "- Browser Cache (Chrome, Firefox, Edge)" -ForegroundColor White
Write-Host "- Windows Store Cache" -ForegroundColor White
Write-Host "- System Cache" -ForegroundColor White
Write-Host "- User Profile Cache" -ForegroundColor White
Write-Host "- Print Spooler Cache" -ForegroundColor White
Write-Host "- Font Cache" -ForegroundColor White
Write-Host ""

$confirm = Read-Host "Do you want to continue? (y/N)"
if ($confirm -ne "y" -and $confirm -ne "Y") {
    Write-Host "Operation cancelled." -ForegroundColor Yellow
    pause
    exit
}

Write-Host ""
Write-Host "Starting cache cleanup process..." -ForegroundColor Yellow
Write-Host ""

# Function to clear directory safely
function Clear-Directory {
    param([string]$Path, [string]$Description)
    
    if (Test-Path $Path) {
        try {
            Remove-Item -Path $Path -Recurse -Force -ErrorAction Stop
            Write-Host "✓ $Description cleared" -ForegroundColor Green
        } catch {
            Write-Host "✗ Failed to clear $Description : $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "- $Description not found" -ForegroundColor Gray
    }
}

# Function to clear files safely
function Clear-Files {
    param([string]$Path, [string]$Pattern, [string]$Description)
    
    if (Test-Path $Path) {
        try {
            Get-ChildItem -Path $Path -Filter $Pattern -Recurse | Remove-Item -Force -ErrorAction Stop
            Write-Host "✓ $Description cleared" -ForegroundColor Green
        } catch {
            Write-Host "✗ Failed to clear $Description : $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "- $Description not found" -ForegroundColor Gray
    }
}

try {
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host "Clearing Windows Update Cache..." -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow
    
    # Stop Windows Update services
    $services = @("wuauserv", "bits", "cryptsvc")
    foreach ($service in $services) {
        try {
            Stop-Service -Name $service -Force -ErrorAction Stop
            Write-Host "✓ Stopped $service service" -ForegroundColor Green
        } catch {
            Write-Host "✗ Failed to stop $service service" -ForegroundColor Red
        }
    }
    
    # Clear Windows Update cache
    Clear-Directory -Path "$env:SystemRoot\SoftwareDistribution\Download" -Description "Windows Update cache"
    Clear-Files -Path "$env:SystemRoot\SoftwareDistribution" -Pattern "*.log" -Description "Windows Update logs"
    
    # Restart Windows Update services
    foreach ($service in $services) {
        try {
            Start-Service -Name $service -ErrorAction Stop
            Write-Host "✓ Started $service service" -ForegroundColor Green
        } catch {
            Write-Host "✗ Failed to start $service service" -ForegroundColor Red
        }
    }
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host "Clearing DNS Cache..." -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow
    
    try {
        Clear-DnsClientCache
        Write-Host "✓ DNS cache flushed" -ForegroundColor Green
    } catch {
        Write-Host "✗ Failed to flush DNS cache" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host "Clearing Temporary Files..." -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow
    
    Clear-Directory -Path $env:TEMP -Description "User temp files"
    Clear-Directory -Path "$env:SystemRoot\Temp" -Description "System temp files"
    
    # Recreate temp directories
    New-Item -ItemType Directory -Path $env:TEMP -Force | Out-Null
    New-Item -ItemType Directory -Path "$env:SystemRoot\Temp" -Force | Out-Null
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host "Clearing Windows Store Cache..." -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow
    
    Get-ChildItem -Path "$env:LOCALAPPDATA\Packages" -Filter "Microsoft.WindowsStore_*" -Directory | ForEach-Object {
        Clear-Directory -Path "$($_.FullName)\LocalCache" -Description "Windows Store cache"
        Clear-Directory -Path "$($_.FullName)\LocalState" -Description "Windows Store state"
    }
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host "Clearing System Cache..." -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow
    
    Clear-Directory -Path "$env:SystemRoot\Prefetch" -Description "Prefetch cache"
    New-Item -ItemType Directory -Path "$env:SystemRoot\Prefetch" -Force | Out-Null
    
    Clear-Files -Path "$env:SystemRoot\System32\winevt\Logs" -Pattern "*.evtx" -Description "Event logs"
    
    Write-Host ""
    Write-Host "=======================================" -ForegroundColor Yellow
    Write-Host "Clearing Browser Cache..." -ForegroundColor Yellow
    Write-Host "=======================================" -ForegroundColor Yellow
    
    # Chrome Cache
    Clear-Directory -Path "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache" -Description "Chrome cache"
    Clear-Directory -Path "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Code Cache" -Description "Chrome code cache"
    
    # Firefox Cache
    if (Test-Path "$env:APPDATA\Mozilla\Firefox\Profiles") {
        Get-ChildItem -Path "$env:APPDATA\Mozilla\Firefox\Profiles" -Directory | ForEach-Object {
            Clear-Directory -Path "$($_.FullName)\cache2" -Description "Firefox cache"
            Clear-Directory -Path "$($_.FullName)\cache" -Description "Firefox cache"
        }
        Write-Host "✓ Firefox cache cleared" -ForegroundColor Green
    }
    
    # Edge Cache
    Clear-Directory -Path "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache" -Description "Edge cache"
    Clear-Directory -Path "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Code Cache" -Description "Edge code cache"
    
    Write-Host ""
    Write-Host "=======================================" -ForegroundColor Yellow
    Write-Host "Clearing User Profile Cache..." -ForegroundColor Yellow
    Write-Host "=======================================" -ForegroundColor Yellow
    
    Clear-Directory -Path "$env:APPDATA\Microsoft\Windows\Recent" -Description "Recent files cache"
    New-Item -ItemType Directory -Path "$env:APPDATA\Microsoft\Windows\Recent" -Force | Out-Null
    
    Clear-Files -Path "$env:APPDATA\Microsoft\Windows\Explorer" -Pattern "thumbcache_*.db" -Description "Thumbnail cache"
    
    Write-Host ""
    Write-Host "=======================================" -ForegroundColor Yellow
    Write-Host "Clearing Print Spooler Cache..." -ForegroundColor Yellow
    Write-Host "=======================================" -ForegroundColor Yellow
    
    try {
        Stop-Service -Name "Spooler" -Force -ErrorAction Stop
        Clear-Directory -Path "$env:SystemRoot\System32\spool\PRINTERS" -Description "Print spooler cache"
        Start-Service -Name "Spooler" -ErrorAction Stop
        Write-Host "✓ Print spooler cache cleared" -ForegroundColor Green
    } catch {
        Write-Host "✗ Failed to clear print spooler cache" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "=======================================" -ForegroundColor Yellow
    Write-Host "Clearing Font Cache..." -ForegroundColor Yellow
    Write-Host "=======================================" -ForegroundColor Yellow
    
    try {
        Stop-Service -Name "FontCache" -Force -ErrorAction Stop
        Clear-Directory -Path "$env:LOCALAPPDATA\Microsoft\Windows\FontCache" -Description "Font cache"
        Start-Service -Name "FontCache" -ErrorAction Stop
        Write-Host "✓ Font cache cleared" -ForegroundColor Green
    } catch {
        Write-Host "✗ Failed to clear font cache" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "=======================================" -ForegroundColor Yellow
    Write-Host "Running Disk Cleanup..." -ForegroundColor Yellow
    Write-Host "=======================================" -ForegroundColor Yellow
    
    try {
        Start-Process -FilePath "cleanmgr" -ArgumentList "/sagerun:1" -Wait -WindowStyle Hidden
        Write-Host "✓ Disk cleanup completed" -ForegroundColor Green
    } catch {
        Write-Host "✗ Failed to run disk cleanup" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "=======================================" -ForegroundColor Green
    Write-Host "Cache Cleanup Complete!" -ForegroundColor Green
    Write-Host "=======================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "All cache has been cleared successfully." -ForegroundColor White
    Write-Host "You may need to restart your computer for all changes to take effect." -ForegroundColor Yellow
    Write-Host ""
    
} catch {
    Write-Host "Error occurred: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 