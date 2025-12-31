# CoreForge - Build to EXE Script

Write-Host "=== CoreForge EXE Builder ===" -ForegroundColor Cyan
Write-Host ""

# Check if PS2EXE is installed
if (-not (Get-Module -ListAvailable -Name ps2exe)) {
    Write-Host "PS2EXE not found. Installing..." -ForegroundColor Yellow
    Install-Module -Name ps2exe -Scope CurrentUser -Force
    Write-Host "PS2EXE installed successfully!" -ForegroundColor Green
}
else {
    Write-Host "PS2EXE already installed." -ForegroundColor Green
}

Import-Module ps2exe

$scriptPath = ".\CoreForge.ps1"
$outputPath = ".\Build\CoreForge.exe"

if (-not (Test-Path ".\Build")) {
    New-Item -ItemType Directory -Path ".\Build" | Out-Null
}

Write-Host ""
Write-Host "Building CoreForge.exe..." -ForegroundColor Cyan
Write-Host "Source: $scriptPath" -ForegroundColor Gray
Write-Host "Output: $outputPath" -ForegroundColor Gray
Write-Host ""

ps2exe -inputFile $scriptPath -outputFile $outputPath `
    -title "CoreForge - Windows Optimizer" `
    -description "Windows Optimization & Management Utility" `
    -company "CoreForge" `
    -product "CoreForge" `
    -version "1.0.0.0" `
    -requireAdmin `
    -noConsole `
    -noOutput `
    -noError

if (Test-Path $outputPath) {
    Write-Host "Build successful!" -ForegroundColor Green
    Write-Host ""
    Write-Host "EXE Location: $((Resolve-Path $outputPath).Path)" -ForegroundColor Cyan
    Write-Host "File Size: $([math]::Round((Get-Item $outputPath).Length / 1MB, 2)) MB" -ForegroundColor Gray
    Write-Host ""
    Write-Host "IMPORTANT: The EXE requires these files in the same directory:" -ForegroundColor Yellow
    Write-Host "  - UI\Main.xaml" -ForegroundColor Gray
    Write-Host "  - Modules\Common.psm1" -ForegroundColor Gray
    Write-Host "  - Modules\System.psm1" -ForegroundColor Gray
    Write-Host "  - Modules\Debloat.psm1" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Creating portable package..." -ForegroundColor Cyan
    
    Copy-Item -Path ".\UI" -Destination ".\Build\UI" -Recurse -Force
    Copy-Item -Path ".\Modules" -Destination ".\Build\Modules" -Recurse -Force
    
    Write-Host "Portable package created in .\Build\" -ForegroundColor Green
    Write-Host ""
    Write-Host "You can now distribute the entire 'Build' folder!" -ForegroundColor Green
}
else {
    Write-Host "Build failed!" -ForegroundColor Red
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
