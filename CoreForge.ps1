<#
    .SYNOPSIS
        CoreForge - Windows Optimization & Management Utility
    .DESCRIPTION
        Main Controller Script. Loads WPF UI and binds logic.
#>

# --- Parameters ---
param()

# --- Assembly Loading ---
Add-Type -AssemblyName PresentationFramework

# --- Constants & Paths ---
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$XamlPath = Join-Path $ScriptPath "UI\Main.xaml"
$ModulesPath = Join-Path $ScriptPath "Modules"

# --- Import Modules ---
Import-Module (Join-Path $ModulesPath "Common.psm1") -Force
Import-Module (Join-Path $ModulesPath "System.psm1") -Force
Import-Module (Join-Path $ModulesPath "Debloat.psm1") -Force



# Helper functions moved to Modules/Common.psm1
# However, Write-Log in Common.psm1 relies on Global scope variables.
# We need to ensure $WPFtxtTerminal matches the one found in this script.
# The FindName calls below put them in the Script scope. We should promote them to Global if Common is separate.


# --- Load XAML ---
if (-not (Test-Path $XamlPath)) {
    Write-Error "Main.xaml not found at $XamlPath"
    exit
}

[xml]$XamlContent = Get-Content $XamlPath
$XamlReader = New-Object System.Xml.XmlNodeReader $XamlContent
$WPFWindow = [System.Windows.Markup.XamlReader]::Load($XamlReader)

# --- Find Controls ---
# We loop through specific controls we need to access by Name
$Controls = "btnScanSystem", "btnApplyTweaks", "btnUndoTweaks", "btnPurgeBloat", "btnScanApps", "btnSelectAll", "btnDeselectAll", "chkSafeMode",
"btnModuleAll", "btnModulePrivacy", "btnModulePerformance", "btnModuleInterface", "btnModuleGaming",
"grpPrivacy", "grpPerformance", "grpInterface", "grpGaming",
"chkDisableTelemetry", "chkDisableLocation", "chkDisableWiFiSense",
"chkHighPerfPlan", "chkDisableHibernation", "chkDisableSysMain",
"chkGameDVR", "chkExplorerPrefs",
"chkEnableGameMode", "chkOptimizeNetwork", "chkDisablePowerThrottle", "chkGamePriority", "chkDisableCoreParking", "chkHardwareGPU", "chkDisableMouseAccel",
"lstInstalledApps", "txtAppCount",
"txtTerminal", "txtSysInfo", "txtRestoreStatus"

foreach ($ctrlName in $Controls) {
    $ctrl = $WPFWindow.FindName($ctrlName)
    if ($ctrl) {
        Set-Variable -Name "WPF$ctrlName" -Value $ctrl -Scope Global
    }
    else {
        Write-Host "Warning: Control $ctrlName not found in XAML." -ForegroundColor Yellow
    }
}


# --- Event Handlers ---

# Module Filter Buttons
$WPFbtnModuleAll.Add_Click({
        $WPFgrpPrivacy.Visibility = "Visible"
        $WPFgrpPerformance.Visibility = "Visible"
        $WPFgrpInterface.Visibility = "Visible"
        $WPFgrpGaming.Visibility = "Visible"
        Write-Log "Showing all tweak categories." "White"
    })

$WPFbtnModulePrivacy.Add_Click({
        $WPFgrpPrivacy.Visibility = "Visible"
        $WPFgrpPerformance.Visibility = "Collapsed"
        $WPFgrpInterface.Visibility = "Collapsed"
        $WPFgrpGaming.Visibility = "Collapsed"
        Write-Log "Filtering: Privacy tweaks only." "Cyan"
    })

$WPFbtnModulePerformance.Add_Click({
        $WPFgrpPrivacy.Visibility = "Collapsed"
        $WPFgrpPerformance.Visibility = "Visible"
        $WPFgrpInterface.Visibility = "Collapsed"
        $WPFgrpGaming.Visibility = "Collapsed"
        Write-Log "Filtering: Performance tweaks only." "Cyan"
    })

$WPFbtnModuleInterface.Add_Click({
        $WPFgrpPrivacy.Visibility = "Collapsed"
        $WPFgrpPerformance.Visibility = "Collapsed"
        $WPFgrpInterface.Visibility = "Visible"
        $WPFgrpGaming.Visibility = "Collapsed"
        Write-Log "Filtering: Interface tweaks only." "Cyan"
    })

$WPFbtnModuleGaming.Add_Click({
        $WPFgrpPrivacy.Visibility = "Collapsed"
        $WPFgrpPerformance.Visibility = "Collapsed"
        $WPFgrpInterface.Visibility = "Collapsed"
        $WPFgrpGaming.Visibility = "Visible"
        Write-Log "Filtering: Gaming tweaks only." "Cyan"
    })

$WPFbtnScanSystem.Add_Click({
        Write-Log "Scanning System Information..." "Cyan"
    
        # Simulate work
        Start-Sleep -Milliseconds 500
    
        $os = Get-CimInstance Win32_OperatingSystem
        $infoText = "OS: $($os.Caption)`nVersion: $($os.Version)`nBuild: $($os.BuildNumber)"
        $WPFtxtSysInfo.Text = $infoText
    
        Write-Log "Scan Complete." "Green"
    })

$WPFbtnApplyTweaks.Add_Click({
        Write-Log "INITIALIZING TWEAK PROTOCOLS..." "Cyan"
    
        $createRestore = $WPFchkSafeMode.IsChecked
    
        Invoke-CoreForgeTask -TaskName "Applying System Tweaks" -CreateRestorePoint $createRestore -Action {
            $script:anySelected = $false
        
            # Privacy
            if ($WPFchkDisableTelemetry.IsChecked) { 
                Disable-Telemetry
                $script:anySelected = $true
            }
        
            # Performance
            if ($WPFchkHighPerfPlan.IsChecked) { 
                Set-PowerPlanUltimate
                $script:anySelected = $true
            }
            if ($WPFchkDisableHibernation.IsChecked) { 
                Disable-Hibernation
                $script:anySelected = $true
            }
            if ($WPFchkDisableSysMain.IsChecked) { 
                Disable-SysMain
                $script:anySelected = $true
            }
        
            # DVR / Explorer
            if ($WPFchkGameDVR.IsChecked) { 
                Remove-GameDVR
                $script:anySelected = $true
            }
            if ($WPFchkExplorerPrefs.IsChecked) { 
                Set-ExplorerOptions
                $script:anySelected = $true
            }
            
            # Gaming Optimizations
            if ($WPFchkEnableGameMode.IsChecked) {
                Enable-GameMode
                $script:anySelected = $true
            }
            if ($WPFchkOptimizeNetwork.IsChecked) {
                Optimize-NetworkForGaming
                $script:anySelected = $true
            }
            if ($WPFchkDisablePowerThrottle.IsChecked) {
                Disable-PowerThrottling
                $script:anySelected = $true
            }
            if ($WPFchkGamePriority.IsChecked) {
                Set-GamePriority
                $script:anySelected = $true
            }
            if ($WPFchkDisableCoreParking.IsChecked) {
                Disable-CPUCoreParking
                $script:anySelected = $true
            }
            if ($WPFchkHardwareGPU.IsChecked) {
                Enable-HardwareAcceleratedGPU
                $script:anySelected = $true
            }
            if ($WPFchkDisableMouseAccel.IsChecked) {
                Disable-MouseAcceleration
                $script:anySelected = $true
            }
            
            if (-not $script:anySelected) {
                Write-Log "No tweaks selected." "Yellow"
            }
        }
    })

$WPFbtnUndoTweaks.Add_Click({
        Write-Log "Rolling back Tweaks..." "Yellow"
        # Basic rollback for demo
        Invoke-CoreForgeTask -TaskName "Rollback Tweaks" -Action {
            Enable-Telemetry
            Enable-MouseAcceleration
        } -CreateRestorePoint $false
    })

# --- Debloat Tab Handlers ---

$WPFbtnScanApps.Add_Click({
        Write-Log "Scanning installed applications..." "Cyan"
        
        $apps = Get-InstalledApps
        
        $WPFWindow.Dispatcher.Invoke([Action] {
                $WPFlstInstalledApps.Items.Clear()
                foreach ($app in $apps) {
                    $WPFlstInstalledApps.Items.Add($app)
                }
                $WPFtxtAppCount.Text = "$($apps.Count) apps detected"
            })
    })

$WPFbtnSelectAll.Add_Click({
        $WPFWindow.Dispatcher.Invoke([Action] {
                $WPFlstInstalledApps.SelectAll()
            })
        Write-Log "Selected all apps in list." "White"
    })

$WPFbtnDeselectAll.Add_Click({
        $WPFWindow.Dispatcher.Invoke([Action] {
                $WPFlstInstalledApps.UnselectAll()
            })
        Write-Log "Deselected all apps." "White"
    })

$WPFbtnPurgeBloat.Add_Click({
        Write-Log "INITIATING DEBLOAT PURGE..." "Red"
    
        $selectedApps = $WPFlstInstalledApps.SelectedItems
        
        if ($selectedApps.Count -eq 0) {
            Write-Log "No apps selected for removal." "Yellow"
            return
        }
        
        # Convert to array
        $appsToRemove = @()
        foreach ($item in $selectedApps) {
            $appsToRemove += $item
        }
        
        Invoke-CoreForgeTask -TaskName "Purging Selected Apps" -CreateRestorePoint $false -Action {
            Remove-SelectedApps -AppObjects $appsToRemove
        }
        
        # Refresh list after removal
        Write-Log "Refreshing app list..." "Cyan"
        $WPFbtnScanApps.RaiseEvent((New-Object System.Windows.RoutedEventArgs([System.Windows.Controls.Button]::ClickEvent)))
    })


# --- Main Execution ---
Write-Log "CoreForge loaded successfully." "Green"

# Show Dialog
$WPFWindow.ShowDialog() | Out-Null
