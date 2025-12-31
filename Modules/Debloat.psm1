<#
    .SYNOPSIS
        Debloat Module for CoreForge
#>

function Get-InstalledApps {
    Write-Log "Scanning installed AppX packages..." "Cyan"
    
    try {
        $apps = Get-AppxPackage | Select-Object Name, Version, PackageFullName | Sort-Object Name
        Write-Log "Found $($apps.Count) installed packages." "Green"
        return $apps
    }
    catch {
        Write-Log "Failed to scan apps: $_" "Red"
        return @()
    }
}

function Remove-SelectedApps {
    param(
        [Parameter(Mandatory = $true)]
        [array]$AppObjects
    )

    if ($AppObjects.Count -eq 0) {
        Write-Log "No apps selected for removal." "Yellow"
        return
    }

    Write-Log "Preparing to remove $($AppObjects.Count) package(s)..." "Yellow"
    
    foreach ($app in $AppObjects) {
        Write-Log "Removing: $($app.Name)..." "Cyan"
        try {
            Get-AppxPackage -Name $app.Name | Remove-AppxPackage -ErrorAction Stop
            Write-Log "Successfully removed: $($app.Name)" "Green"
        }
        catch {
            Write-Log "Failed to remove $($app.Name): $_" "Red"
        }
    }
    
    Write-Log "Debloat operation complete." "Green"
}

function Remove-Bloatware {
    param(
        [string[]]$PackageKeywords
    )

    foreach ($keyword in $PackageKeywords) {
        Write-Log "Searching for bloatware: *$keyword* ..." "White"
        $pkg = Get-AppxPackage -Name "*$keyword*" -ErrorAction SilentlyContinue
        
        if ($pkg) {
            Write-Log "Removing $($pkg.Name) ..." "Cyan"
            try {
                $pkg | Remove-AppxPackage -ErrorAction Stop
                Write-Log "Removed $($pkg.Name)." "Green"
            }
            catch {
                Write-Log "Failed to remove $($pkg.Name): $_" "Red"
            }
        }
        else {
            Write-Log "Package *$keyword* not found or already removed." "White"
        }
    }
}

Export-ModuleMember -Function Get-InstalledApps, Remove-SelectedApps, Remove-Bloatware
