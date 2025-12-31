# CoreForge - Windows Optimization Utility

A modular Windows optimization tool built with PowerShell and WPF.

## Features

### Privacy & Telemetry
- Disable Windows Telemetry (DiagTrack)
- Disable Location Tracking
- Disable Wi-Fi Sense

### Performance
- Enable Ultimate Performance Power Plan
- Disable Hibernation
- Disable SysMain (Superfetch)

### Gaming Optimizations
- Enable Windows Game Mode
- Optimize Network (Disable Nagle's Algorithm, Network Throttling)
- Disable CPU Power Throttling
- Set Game Priority (MMCSS - GPU Priority 8, CPU Priority 6)
- Disable CPU Core Parking
- Enable Hardware-Accelerated GPU Scheduling

### Interface
- Disable Xbox Game DVR
- Show File Extensions & Hidden Files

### Debloat
- Dynamic app scanner for all installed AppX packages
- Multi-select removal interface
- Remove common bloatware (Bing, Zune, Solitaire, Xbox Overlay, Cortana, etc.)

### Safety
- System Restore Point creation before applying tweaks
- Try-Catch error handling on all registry modifications
- Rollback functionality for critical tweaks
- Real-time terminal logging

## Installation

### Requirements
- Windows 10/11
- PowerShell 5.1 or 7+
- Administrator privileges

### Method 1: Run from Web (Recommended)

```powershell
irm https://your-url.com/CoreForge-Standalone.ps1 | iex
```

See [WEB-DEPLOYMENT.md](WEB-DEPLOYMENT.md) for hosting instructions.

### Method 2: Run Locally

```powershell
cd C:\Path\To\CoreForge
.\CoreForge.ps1
```

### Method 3: Build to EXE

```powershell
.\Build-EXE.ps1
```

Output will be in `Build\CoreForge.exe`. See [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md) for details.

## Project Structure

```
CoreForge/
├── CoreForge.ps1              # Main script
├── CoreForge-Standalone.ps1   # All-in-one version for web deployment
├── Build-EXE.ps1             # EXE build script
├── UI/
│   └── Main.xaml             # WPF interface
└── Modules/
    ├── Common.psm1           # Safety wrappers, logging
    ├── System.psm1           # System tweaks & gaming optimizations
    └── Debloat.psm1          # App removal functions
```

## Usage

### Running the Tool

1. Open PowerShell as Administrator
2. Navigate to CoreForge directory
3. Run `.\CoreForge.ps1`

### Applying Tweaks

1. Open the NEURAL_TWEAKS tab
2. Use sidebar filters to view specific categories:
   - ALL_TWEAKS: Show everything
   - PRIVACY_SHIELD: Privacy tweaks only
   - PERFORMANCE_CORE: Performance tweaks only
   - INTERFACE_MODS: Interface tweaks only
   - GAMING_BOOST: Gaming optimizations only
3. Select desired tweaks
4. Click EXECUTE_TWEAKS

### Debloating Apps

1. Open PURGE_APPS tab
2. Click SCAN_SYSTEM to load installed apps
3. Select apps to remove
4. Click PURGE_SELECTED

### Configuration

Open CONFIG_NODE tab to:
- Enable/disable automatic System Restore Points
- Enable/disable log file saving

## Gaming Optimizations Explained

**Enable Game Mode**: Activates Windows built-in Game Mode to prioritize game processes.

**Optimize Network**: Disables Nagle's Algorithm and Network Throttling to reduce ping and latency.

**Disable Power Throttling**: Prevents Windows from limiting CPU/GPU performance.

**Set Game Priority**: Configures MMCSS to allocate maximum resources to games (GPU Priority 8, CPU Priority 6, System Responsiveness 0).

**Disable CPU Core Parking**: Prevents CPU cores from entering low-power states, eliminating stuttering.

**Hardware-Accelerated GPU Scheduling**: Offloads GPU scheduling from CPU to GPU, reducing input latency. Requires restart.

**Disable Mouse Acceleration**: Disables Windows pointer acceleration (MouseThreshold1/2=0) for 1:1 precise mouse control in competitive gaming.

## Safety & Rollback

### System Restore Points
Automatically created before applying tweaks if enabled in Config tab. To restore manually:
`Control Panel → System → System Protection → System Restore`

### Rollback
Click ROLLBACK button to revert telemetry changes. Some tweaks may require manual reversion.

### Logging
All actions are logged in real-time to the Terminal Output section.

## Troubleshooting

**"Requested registry access is not allowed"**
Run as Administrator.

**Execution Policy Error**
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
```

**UI doesn't load**
Ensure `UI\Main.xaml` exists in the same directory.

**EXE not working**
Right-click CoreForge.exe → Run as administrator. See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for details.

## Building to EXE

```powershell
.\Build-EXE.ps1
```

Creates portable package in `Build\` folder containing:
- CoreForge.exe
- UI\Main.xaml
- Modules\ (all .psm1 files)

Distribute the entire Build folder.

## Web Deployment

Use `CoreForge-Standalone.ps1` for web-based deployment via `irm` command. See [WEB-DEPLOYMENT.md](WEB-DEPLOYMENT.md) for hosting instructions.

## License

MIT License

## Disclaimer

Use at your own risk. While CoreForge includes safety features like System Restore Points and error handling, modifying system settings and registry can potentially cause issues. Always create a backup before using and test on a non-critical system first.
