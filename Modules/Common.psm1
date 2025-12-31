<#
    .SYNOPSIS
        Common Helper Functions for CoreForge
#>

# Using 'Global' scope for these to ensure they are accessible if not properly exported or if scoping issues arise in XAML events
# But standard Export-ModuleMember is better.

function Write-Log {
    param (
        [string]$Message,
        [string]$Color = "White"
    )
    # This relies on $WPFWindow and $WPFtxtTerminal being available in the Global/Script scope of the caller
    # We'll check if they exist to avoid errors during non-GUI testing
    if ($Global:WPFWindow -and $Global:WPFtxtTerminal) {
        $Global:WPFWindow.Dispatcher.Invoke([Action] {
                $paragraph = New-Object System.Windows.Documents.Paragraph
                $run = New-Object System.Windows.Documents.Run
                $run.Text = "$(Get-Date -Format 'HH:mm:ss') - $Message"
            
                switch ($Color.ToLower()) {
                    "green" { $run.Foreground = [System.Windows.Media.Brushes]::LimeGreen }
                    "red" { $run.Foreground = [System.Windows.Media.Brushes]::Red }
                    "yellow" { $run.Foreground = [System.Windows.Media.Brushes]::Yellow }
                    "cyan" { $run.Foreground = [System.Windows.Media.Brushes]::Cyan }
                    default { $run.Foreground = [System.Windows.Media.Brushes]::White }
                }

                $paragraph.Inlines.Add($run)
                $Global:WPFtxtTerminal.Document.Blocks.Add($paragraph)
                $Global:WPFtxtTerminal.ScrollToEnd()
            })
    }
    else {
        Write-Host "$Color : $Message"
    }
}

function New-SystemRestorePointSafe {
    param([string]$Description = "CoreForge Auto-Restore Point")
    
    try {
        Write-Log "Checking System Restore capability..." "Yellow"
        # Enable System Restore if disabled? (Might be too aggressive, let's just create)
        # Verify Admin
        $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
        if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            Write-Log "WARNING: Not running as Admin. Cannot create Restore Point." "Red"
            return $false
        }

        Checkpoint-Computer -Description $Description -RestorePointType MODIFY_SETTINGS -ErrorAction Stop
        Write-Log "System Restore Point created successfully." "Green"
        return $true
    }
    catch {
        Write-Log "Failed to create Restore Point: $_" "Red"
        return $false
    }
}

function Invoke-CoreForgeTask {
    param (
        [string]$TaskName,
        [scriptblock]$Action,
        [bool]$CreateRestorePoint = $false
    )

    Write-Log "Starting Task: $TaskName" "Cyan"

    if ($CreateRestorePoint) {
        $rpResult = New-SystemRestorePointSafe -Description "Before $TaskName"
        if (-not $rpResult) {
            Write-Log "Restore Point creation failed. Aborting task for safety." "Red"
            return
        }
    }

    try {
        & $Action
        Write-Log "Task '$TaskName' completed successfully." "Green"
    }
    catch {
        Write-Log "Error during '$TaskName': $_" "Red"
        # In a real scenario, we might attempt rollback here if the Action supports it
    }
}

Export-ModuleMember -Function Write-Log, New-SystemRestorePointSafe, Invoke-CoreForgeTask
