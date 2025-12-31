<#
    .SYNOPSIS
        System Tweaks Module for CoreForge
#>

function Disable-Telemetry {
    Write-Log "Disabling Windows Telemetry..." "Yellow"
    $Paths = @(
        "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection",
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
    )
    foreach ($path in $Paths) {
        if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
        Set-ItemProperty -Path $path -Name "AllowTelemetry" -Value 0 -Force -ErrorAction Stop
    }
    
    $Services = "DiagTrack", "dmwappushservice"
    foreach ($svc in $Services) {
        if (Get-Service $svc -ErrorAction SilentlyContinue) {
            Stop-Service $svc -Force -ErrorAction SilentlyContinue
            Set-Service $svc -StartupType Disabled -ErrorAction SilentlyContinue
        }
    }
    Write-Log "Telemetry disabled." "Green"
}

function Enable-Telemetry {
    Write-Log "Re-enabling Windows Telemetry..." "Yellow"
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -ErrorAction SilentlyContinue
    # Basic restore
    $Services = "DiagTrack", "dmwappushservice"
    foreach ($svc in $Services) {
        Set-Service $svc -StartupType Automatic -ErrorAction SilentlyContinue
        Start-Service $svc -ErrorAction SilentlyContinue
    }
    Write-Log "Telemetry re-enabled." "Green"
}

function Set-PowerPlanUltimate {
    Write-Log "Enabling Ultimate Performance Plan..." "Yellow"
    # Duplicate Scheme
    $output = powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>&1
    if ($output -match "Power Scheme GUID: ([a-z0-9\-]+)") {
        $guid = $matches[1]
        powercfg -setactive $guid
        Write-Log "Ultimate Performance Plan Active ($guid)." "Green"
    }
    else {
        Write-Log "Failed to create Ultimate Plan (May already exist or not supported)." "Red"
    }
}

function Disable-Hibernation {
    Write-Log "Disabling Hibernation..." "Yellow"
    powercfg -h off
    Write-Log "Hibernation Disabled. Space reclaimed." "Green"
}

function Disable-SysMain {
    Write-Log "Disabling SysMain (Superfetch)..." "Yellow"
    Stop-Service "SysMain" -Force -ErrorAction SilentlyContinue
    Set-Service "SysMain" -StartupType Disabled -ErrorAction SilentlyContinue
    Write-Log "SysMain Disabled." "Green"
}

function Remove-GameDVR {
    Write-Log "Disabling Xbox Game DVR..." "Yellow"
    $Reg = "HKCU:\System\GameConfigStore"
    if (-not (Test-Path $Reg)) { New-Item $Reg -Force | Out-Null }
    Set-ItemProperty -Path $Reg -Name "GameDVR_Enabled" -Value 0 -Force

    $Reg2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"
    if (-not (Test-Path $Reg2)) { New-Item $Reg2 -Force | Out-Null }
    Set-ItemProperty -Path $Reg2 -Name "AllowGameDVR" -Value 0 -Force
    Write-Log "Game DVR Disabled." "Green"
}

function Set-ExplorerOptions {
    Write-Log "Setting Explorer Preferences (Show Ext, Show Hidden)..." "Yellow"
    $Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    Set-ItemProperty -Path $Path -Name "Hidden" -Value 1 -Force  # Show Hidden
    Set-ItemProperty -Path $Path -Name "HideFileExt" -Value 0 -Force # Show Extensions
    
    # Restart Explorer? Usually not needed strictly immediately, but good practice
    # Stop-Process -Name explorer -Force
    Write-Log "Explorer Preferences Updated." "Green"
}

# ===== GAMING OPTIMIZATIONS =====

function Enable-GameMode {
    Write-Log "Enabling Windows Game Mode..." "Yellow"
    $Path = "HKCU:\Software\Microsoft\GameBar"
    if (-not (Test-Path $Path)) { New-Item $Path -Force | Out-Null }
    Set-ItemProperty -Path $Path -Name "AutoGameModeEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $Path -Name "AllowAutoGameMode" -Value 1 -Type DWord -Force
    Write-Log "Game Mode Enabled." "Green"
}

function Optimize-NetworkForGaming {
    Write-Log "Optimizing Network for Gaming (Disable Nagle, Network Throttling)..." "Yellow"
    
    # Disable Network Throttling
    $Path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
    if (-not (Test-Path $Path)) { New-Item $Path -Force | Out-Null }
    Set-ItemProperty -Path $Path -Name "NetworkThrottlingIndex" -Value 0xffffffff -Type DWord -Force
    
    # Disable Nagle's Algorithm (requires finding network adapter)
    try {
        $adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
        foreach ($adapter in $adapters) {
            $interfaceGuid = $adapter | Get-NetAdapterBinding | Select-Object -First 1 -ExpandProperty InstanceID
            if ($interfaceGuid) {
                $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$interfaceGuid"
                if (Test-Path $regPath) {
                    Set-ItemProperty -Path $regPath -Name "TcpAckFrequency" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
                    Set-ItemProperty -Path $regPath -Name "TCPNoDelay" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
                }
            }
        }
        Write-Log "Network optimized for gaming." "Green"
    }
    catch {
        Write-Log "Network optimization partially applied: $_" "Yellow"
    }
}

function Disable-PowerThrottling {
    Write-Log "Disabling CPU Power Throttling..." "Yellow"
    $Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling"
    if (-not (Test-Path $Path)) { New-Item $Path -Force | Out-Null }
    Set-ItemProperty -Path $Path -Name "PowerThrottlingOff" -Value 1 -Type DWord -Force
    Write-Log "Power Throttling Disabled." "Green"
}

function Set-GamePriority {
    Write-Log "Setting Game Priority (MMCSS Tweaks)..." "Yellow"
    
    # System Responsiveness (0 = all CPU for foreground)
    $Path1 = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
    if (-not (Test-Path $Path1)) { New-Item $Path1 -Force | Out-Null }
    Set-ItemProperty -Path $Path1 -Name "SystemResponsiveness" -Value 0 -Type DWord -Force
    
    # Game Task Priority
    $Path2 = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
    if (-not (Test-Path $Path2)) { New-Item $Path2 -Force | Out-Null }
    Set-ItemProperty -Path $Path2 -Name "GPU Priority" -Value 8 -Type DWord -Force
    Set-ItemProperty -Path $Path2 -Name "Priority" -Value 6 -Type DWord -Force
    Set-ItemProperty -Path $Path2 -Name "Scheduling Category" -Value "High" -Type String -Force
    Set-ItemProperty -Path $Path2 -Name "SFIO Priority" -Value "High" -Type String -Force
    
    Write-Log "Game Priority Optimized." "Green"
}

function Disable-CPUCoreParking {
    Write-Log "Disabling CPU Core Parking..." "Yellow"
    $Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583"
    if (Test-Path $Path) {
        Set-ItemProperty -Path $Path -Name "Attributes" -Value 0 -Type DWord -Force
        Write-Log "CPU Core Parking Disabled (Check Power Options to configure)." "Green"
    }
    else {
        Write-Log "Core Parking registry path not found (may not be supported)." "Yellow"
    }
}

function Enable-HardwareAcceleratedGPU {
    Write-Log "Enabling Hardware-Accelerated GPU Scheduling..." "Yellow"
    $Path = "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers"
    if (-not (Test-Path $Path)) { New-Item $Path -Force | Out-Null }
    Set-ItemProperty -Path $Path -Name "HwSchMode" -Value 2 -Type DWord -Force
    Write-Log "Hardware-Accelerated GPU Scheduling Enabled (Restart required)." "Green"
}

Export-ModuleMember -Function Disable-Telemetry, Enable-Telemetry, Set-PowerPlanUltimate, Disable-Hibernation, Disable-SysMain, Remove-GameDVR, Set-ExplorerOptions, Enable-GameMode, Optimize-NetworkForGaming, Disable-PowerThrottling, Set-GamePriority, Disable-CPUCoreParking, Enable-HardwareAcceleratedGPU
