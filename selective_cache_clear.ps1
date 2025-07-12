# Selective Cache Clear - Windows System
# Run this script as Administrator

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script requires Administrator privileges. Please run as Administrator." -ForegroundColor Red
    Write-Host "Right-click on PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    pause
    exit
}

function Show-Menu {
    Clear-Host
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "      Selective Cache Clear Menu" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Select which cache to clear:" -ForegroundColor White
    Write-Host "1. Windows Update Cache" -ForegroundColor Yellow
    Write-Host "2. DNS Cache" -ForegroundColor Yellow
    Write-Host "3. Temporary Files" -ForegroundColor Yellow
    Write-Host "4. Browser Cache (All browsers)" -ForegroundColor Yellow
    Write-Host "5. Windows Store Cache" -ForegroundColor Yellow
    Write-Host "6. System Cache (Prefetch, Event logs)" -ForegroundColor Yellow
    Write-Host "7. User Profile Cache" -ForegroundColor Yellow
    Write-Host "8. Print Spooler Cache" -ForegroundColor Yellow
    Write-Host "9. Font Cache" -ForegroundColor Yellow
    Write-Host "10. All Cache (Complete cleanup)" -ForegroundColor Green
    Write-Host "0. Exit" -ForegroundColor Red
    Write-Host ""
}

function Clear-WindowsUpdateCache {
    Write-Host "Clearing Windows Update Cache..." -ForegroundColor Yellow
    
    $services = @("wuauserv", "bits", "cryptsvc")
    foreach ($service in $services) {
        try {
            Stop-Service -Name $service -Force -ErrorAction Stop
            Write-Host "✓ Stopped $service service" -ForegroundColor Green
        } catch {
            Write-Host "✗ Failed to stop $service service" -ForegroundColor Red
        }
    }
    
    if (Test-Path "$env:SystemRoot\SoftwareDistribution\Download") {
        Remove-Item -Path "$env:SystemRoot\SoftwareDistribution\Download" -Recurse -Force
        Write-Host "✓ Windows Update cache cleared" -ForegroundColor Green
    }
    
    if (Test-Path "$env:SystemRoot\SoftwareDistribution\ReportingEvents.log") {
        Remove-Item -Path "$env:SystemRoot\SoftwareDistribution\ReportingEvents.log" -Force
        Write-Host "✓ Windows Update log cleared" -ForegroundColor Green
    }
    
    foreach ($service in $services) {
        try {
            Start-Service -Name $service -ErrorAction Stop
            Write-Host "✓ Started $service service" -ForegroundColor Green
        } catch {
            Write-Host "✗ Failed to start $service service" -ForegroundColor Red
        }
    }
}

function Clear-DnsCache {
    Write-Host "Clearing DNS Cache..." -ForegroundColor Yellow
    try {
        Clear-DnsClientCache
        Write-Host "✓ DNS cache flushed" -ForegroundColor Green
    } catch {
        Write-Host "✗ Failed to flush DNS cache" -ForegroundColor Red
    }
}

function Clear-TempFiles {
    Write-Host "Clearing Temporary Files..." -ForegroundColor Yellow
    
    if (Test-Path $env:TEMP) {
        Remove-Item -Path $env:TEMP -Recurse -Force
        New-Item -ItemType Directory -Path $env:TEMP -Force | Out-Null
        Write-Host "✓ User temp files cleared" -ForegroundColor Green
    }
    
    if (Test-Path "$env:SystemRoot\Temp") {
        Remove-Item -Path "$env:SystemRoot\Temp" -Recurse -Force
        New-Item -ItemType Directory -Path "$env:SystemRoot\Temp" -Force | Out-Null
        Write-Host "✓ System temp files cleared" -ForegroundColor Green
    }
}

function Clear-BrowserCache {
    Write-Host "Clearing Browser Cache..." -ForegroundColor Yellow
    
    # Chrome
    if (Test-Path "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache") {
        Remove-Item -Path "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache" -Recurse -Force
        Write-Host "✓ Chrome cache cleared" -ForegroundColor Green
    }
    
    if (Test-Path "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Code Cache") {
        Remove-Item -Path "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Code Cache" -Recurse -Force
        Write-Host "✓ Chrome code cache cleared" -ForegroundColor Green
    }
    
    # Firefox
    if (Test-Path "$env:APPDATA\Mozilla\Firefox\Profiles") {
        Get-ChildItem -Path "$env:APPDATA\Mozilla\Firefox\Profiles" -Directory | ForEach-Object {
            if (Test-Path "$($_.FullName)\cache2") {
                Remove-Item -Path "$($_.FullName)\cache2" -Recurse -Force
            }
            if (Test-Path "$($_.FullName)\cache") {
                Remove-Item -Path "$($_.FullName)\cache" -Recurse -Force
            }
        }
        Write-Host "✓ Firefox cache cleared" -ForegroundColor Green
    }
    
    # Edge
    if (Test-Path "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache") {
        Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache" -Recurse -Force
        Write-Host "✓ Edge cache cleared" -ForegroundColor Green
    }
    
    if (Test-Path "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Code Cache") {
        Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Code Cache" -Recurse -Force
        Write-Host "✓ Edge code cache cleared" -ForegroundColor Green
    }
}

function Clear-WindowsStoreCache {
    Write-Host "Clearing Windows Store Cache..." -ForegroundColor Yellow
    
    Get-ChildItem -Path "$env:LOCALAPPDATA\Packages" -Filter "Microsoft.WindowsStore_*" -Directory | ForEach-Object {
        if (Test-Path "$($_.FullName)\LocalCache") {
            Remove-Item -Path "$($_.FullName)\LocalCache" -Recurse -Force
        }
        if (Test-Path "$($_.FullName)\LocalState") {
            Remove-Item -Path "$($_.FullName)\LocalState" -Recurse -Force
        }
    }
    Write-Host "✓ Windows Store cache cleared" -ForegroundColor Green
}

function Clear-SystemCache {
    Write-Host "Clearing System Cache..." -ForegroundColor Yellow
    
    if (Test-Path "$env:SystemRoot\Prefetch") {
        Remove-Item -Path "$env:SystemRoot\Prefetch" -Recurse -Force
        New-Item -ItemType Directory -Path "$env:SystemRoot\Prefetch" -Force | Out-Null
        Write-Host "✓ Prefetch cache cleared" -ForegroundColor Green
    }
    
    if (Test-Path "$env:SystemRoot\System32\winevt\Logs") {
        Get-ChildItem -Path "$env:SystemRoot\System32\winevt\Logs" -Filter "*.evtx" | Remove-Item -Force
        Write-Host "✓ Event logs cleared" -ForegroundColor Green
    }
}

function Clear-UserProfileCache {
    Write-Host "Clearing User Profile Cache..." -ForegroundColor Yellow
    
    if (Test-Path "$env:APPDATA\Microsoft\Windows\Recent") {
        Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Recent" -Recurse -Force
        New-Item -ItemType Directory -Path "$env:APPDATA\Microsoft\Windows\Recent" -Force | Out-Null
        Write-Host "✓ Recent files cache cleared" -ForegroundColor Green
    }
    
    if (Test-Path "$env:APPDATA\Microsoft\Windows\Explorer") {
        Get-ChildItem -Path "$env:APPDATA\Microsoft\Windows\Explorer" -Filter "thumbcache_*.db" | Remove-Item -Force
        Write-Host "✓ Thumbnail cache cleared" -ForegroundColor Green
    }
}

function Clear-PrintSpoolerCache {
    Write-Host "Clearing Print Spooler Cache..." -ForegroundColor Yellow
    
    try {
        Stop-Service -Name "Spooler" -Force -ErrorAction Stop
        if (Test-Path "$env:SystemRoot\System32\spool\PRINTERS") {
            Remove-Item -Path "$env:SystemRoot\System32\spool\PRINTERS" -Recurse -Force
        }
        Start-Service -Name "Spooler" -ErrorAction Stop
        Write-Host "✓ Print spooler cache cleared" -ForegroundColor Green
    } catch {
        Write-Host "✗ Failed to clear print spooler cache" -ForegroundColor Red
    }
}

function Clear-FontCache {
    Write-Host "Clearing Font Cache..." -ForegroundColor Yellow
    
    try {
        Stop-Service -Name "FontCache" -Force -ErrorAction Stop
        if (Test-Path "$env:LOCALAPPDATA\Microsoft\Windows\FontCache") {
            Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Windows\FontCache" -Recurse -Force
        }
        Start-Service -Name "FontCache" -ErrorAction Stop
        Write-Host "✓ Font cache cleared" -ForegroundColor Green
    } catch {
        Write-Host "✗ Failed to clear font cache" -ForegroundColor Red
    }
}

function Clear-AllCache {
    Write-Host "Clearing All Cache..." -ForegroundColor Yellow
    Clear-WindowsUpdateCache
    Clear-DnsCache
    Clear-TempFiles
    Clear-BrowserCache
    Clear-WindowsStoreCache
    Clear-SystemCache
    Clear-UserProfileCache
    Clear-PrintSpoolerCache
    Clear-FontCache
    
    Write-Host ""
    Write-Host "Running Disk Cleanup..." -ForegroundColor Yellow
    try {
        Start-Process -FilePath "cleanmgr" -ArgumentList "/sagerun:1" -Wait -WindowStyle Hidden
        Write-Host "✓ Disk cleanup completed" -ForegroundColor Green
    } catch {
        Write-Host "✗ Failed to run disk cleanup" -ForegroundColor Red
    }
}

# Main menu loop
do {
    Show-Menu
    $choice = Read-Host "Enter your choice (0-10)"
    
    switch ($choice) {
        "1" { 
            Clear-WindowsUpdateCache
            Write-Host ""
            Write-Host "Press any key to continue..."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        "2" { 
            Clear-DnsCache
            Write-Host ""
            Write-Host "Press any key to continue..."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        "3" { 
            Clear-TempFiles
            Write-Host ""
            Write-Host "Press any key to continue..."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        "4" { 
            Clear-BrowserCache
            Write-Host ""
            Write-Host "Press any key to continue..."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        "5" { 
            Clear-WindowsStoreCache
            Write-Host ""
            Write-Host "Press any key to continue..."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        "6" { 
            Clear-SystemCache
            Write-Host ""
            Write-Host "Press any key to continue..."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        "7" { 
            Clear-UserProfileCache
            Write-Host ""
            Write-Host "Press any key to continue..."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        "8" { 
            Clear-PrintSpoolerCache
            Write-Host ""
            Write-Host "Press any key to continue..."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        "9" { 
            Clear-FontCache
            Write-Host ""
            Write-Host "Press any key to continue..."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        "10" { 
            Clear-AllCache
            Write-Host ""
            Write-Host "All cache has been cleared successfully!" -ForegroundColor Green
            Write-Host "You may need to restart your computer for all changes to take effect." -ForegroundColor Yellow
            Write-Host ""
            Write-Host "Press any key to continue..."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        "0" { 
            Write-Host "Exiting..." -ForegroundColor Yellow
            exit
        }
        default { 
            Write-Host "Invalid choice. Please try again." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
} while ($choice -ne "0") 