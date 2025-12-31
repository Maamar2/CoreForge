# CoreForge - Quick Start Guide

## Three Ways to Use CoreForge

### 1. Web-Based (One Command)

**Best for:** Easy distribution, always up-to-date

**Steps:**
1. Host `CoreForge-Standalone.ps1` on GitHub (see WEB-DEPLOYMENT.md)
2. Users run this command as Administrator:
```powershell
irm https://raw.githubusercontent.com/YOUR-USERNAME/CoreForge/main/CoreForge-Standalone.ps1 | iex
```

### 2. Local PowerShell Script

**Best for:** Full features, offline use

**Steps:**
1. Download the CoreForge folder
2. Open PowerShell as Administrator
3. Run:
```powershell
cd C:\Users\20010\Desktop\CoreForge
.\CoreForge.ps1
```

### 3. Standalone EXE

**Best for:** Professional distribution, no PowerShell needed

**Steps:**
1. Build the EXE:
```powershell
.\Build-EXE.ps1
```
2. Distribute the entire `Build\` folder
3. Users right-click `CoreForge.exe` → Run as administrator

## File Overview

**CoreForge.ps1** - Main script with full features (requires UI and Modules folders)

**CoreForge-Standalone.ps1** - All-in-one version for web deployment (no dependencies)

**Build-EXE.ps1** - Converts CoreForge.ps1 to executable

**Build-DEBUG.ps1** - Creates debug EXE with console output

**Test-EXE.ps1** - Tests the EXE and shows errors

## Common Issues

**Script won't run**
- Solution: Run PowerShell as Administrator

**"Execution policy" error**
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
```

**EXE flashes and closes**
- Solution: Right-click → Run as administrator
- Or run `.\Build-DEBUG.ps1` and check console output

**Registry access denied**
- Solution: Must run as Administrator

## Next Steps

1. Test locally: `.\CoreForge.ps1`
2. If working, choose deployment method:
   - Web: Upload `CoreForge-Standalone.ps1` to GitHub
   - EXE: Run `.\Build-EXE.ps1` and distribute Build folder
3. Share with users

## Support Files

- `README.md` - Full documentation
- `BUILD_INSTRUCTIONS.md` - EXE build guide
- `WEB-DEPLOYMENT.md` - Web hosting guide
- `TROUBLESHOOTING.md` - Common issues and fixes
