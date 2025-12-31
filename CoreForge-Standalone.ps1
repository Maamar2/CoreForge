<#
    .SYNOPSIS
        CoreForge - Windows Optimization Utility (Standalone Version)
    .DESCRIPTION
        All-in-one script with embedded XAML and modules for web deployment
    .NOTES
        Run with: irm https://your-url.com/CoreForge.ps1 | iex
#>

#Requires -RunAsAdministrator

# --- Embedded XAML ---
$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="COREFORGE // SYSTEM OPTIMIZER" Height="750" Width="1100"
        WindowStartupLocation="CenterScreen"
        Background="#0B0D17" Foreground="#E0E6ED"
        FontFamily="Consolas" FontSize="14"
        SnapsToDevicePixels="True" UseLayoutRounding="True"
        BorderBrush="#00F3FF" BorderThickness="1">

    <Window.Resources>
        <!-- Cyberpunk Palette -->
        <SolidColorBrush x:Key="CyberBlack" Color="#0B0D17"/>
        <SolidColorBrush x:Key="CyberDark" Color="#151922"/>
        <SolidColorBrush x:Key="CyberPanel" Color="#1A1C29"/>
        <SolidColorBrush x:Key="NeonCyan" Color="#00F3FF"/>
        <SolidColorBrush x:Key="NeonPink" Color="#FF00FF"/>
        <SolidColorBrush x:Key="NeonYellow" Color="#FCEE0A"/>
        <SolidColorBrush x:Key="TextPrimary" Color="#E0E6ED"/>
        <SolidColorBrush x:Key="TextDim" Color="#8B9BB4"/>

        <!-- Cyber Button Style -->
        <Style TargetType="Button">
            <Setter Property="Background" Value="{StaticResource CyberPanel}"/>
            <Setter Property="Foreground" Value="{StaticResource NeonCyan}"/>
            <Setter Property="BorderBrush" Value="{StaticResource NeonCyan}"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Padding" Value="15,8"/>
            <Setter Property="Margin" Value="5"/>
            <Setter Property="FontFamily" Value="Consolas"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Name="Border" Background="{TemplateBinding Background}" 
                                BorderBrush="{TemplateBinding BorderBrush}" 
                                BorderThickness="{TemplateBinding BorderThickness}" 
                                CornerRadius="0">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="Border" Property="Background" Value="#1F2A3D"/>
                                <Setter TargetName="Border" Property="BorderBrush" Value="{StaticResource NeonPink}"/>
                                <Setter Property="Foreground" Value="{StaticResource NeonPink}"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="Border" Property="Background" Value="{StaticResource NeonCyan}"/>
                                <Setter Property="Foreground" Value="{StaticResource CyberBlack}"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- TabControl Style -->
        <Style TargetType="TabControl">
            <Setter Property="Background" Value="{StaticResource CyberBlack}"/>
            <Setter Property="BorderThickness" Value="0"/>
        </Style>

        <Style TargetType="TabItem">
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Foreground" Value="{StaticResource TextDim}"/>
            <Setter Property="FontSize" Value="16"/>
            <Setter Property="Padding" Value="20,10"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TabItem">
                        <Grid>
                            <Border Name="Border" Background="Transparent" 
                                    BorderBrush="{StaticResource NeonCyan}" 
                                    BorderThickness="0,0,0,0" 
                                    Margin="0,0,5,0">
                                <ContentPresenter x:Name="ContentSite"
                                                VerticalAlignment="Center"
                                                HorizontalAlignment="Center"
                                                ContentSource="Header"
                                                Margin="10,5"/>
                            </Border>
                        </Grid>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsSelected" Value="True">
                                <Setter TargetName="Border" Property="BorderThickness" Value="0,0,0,2"/>
                                <Setter Property="Foreground" Value="{StaticResource NeonCyan}"/>
                                <Setter Property="FontWeight" Value="Bold"/>
                            </Trigger>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Foreground" Value="{StaticResource NeonPink}"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- GroupBox Style -->
        <Style TargetType="GroupBox">
            <Setter Property="Foreground" Value="{StaticResource NeonCyan}"/>
            <Setter Property="BorderBrush" Value="{StaticResource NeonCyan}"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Margin" Value="5,10,5,5"/>
        </Style>
        
        <Style TargetType="CheckBox">
            <Setter Property="Foreground" Value="{StaticResource TextPrimary}"/>
            <Setter Property="Margin" Value="0,5"/>
            <Setter Property="FontSize" Value="14"/>
        </Style>

    </Window.Resources>

    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="200"/>
        </Grid.RowDefinitions>

        <!-- Header -->
        <Border Grid.Row="0" Background="{StaticResource CyberPanel}" Padding="15">
            <TextBlock Text="COREFORGE // v1.0 [WEB EDITION]" Foreground="{StaticResource NeonCyan}" FontSize="24" FontWeight="Bold" FontFamily="Courier New"/>
        </Border>

        <!-- Main Tabs -->
        <TabControl Grid.Row="1" Margin="10">
            
            <TabItem Header="STATUS_DECK">
                <Grid Margin="20">
                    <TextBlock Text="CoreForge Web Edition - Run with: irm url | iex" 
                               FontSize="18" Foreground="{StaticResource NeonCyan}" 
                               HorizontalAlignment="Center" VerticalAlignment="Center"/>
                </Grid>
            </TabItem>

            <TabItem Header="TWEAKS">
                <ScrollViewer Margin="20">
                    <StackPanel>
                        <GroupBox Header="GAMING_BOOST">
                            <StackPanel Margin="10">
                                <CheckBox Name="chkEnableGameMode" Content="Enable Windows Game Mode"/>
                                <CheckBox Name="chkOptimizeNetwork" Content="Optimize Network for Gaming"/>
                                <CheckBox Name="chkDisablePowerThrottle" Content="Disable CPU Power Throttling"/>
                                <CheckBox Name="chkGamePriority" Content="Set Game Priority (MMCSS)"/>
                                <CheckBox Name="chkDisableCoreParking" Content="Disable CPU Core Parking"/>
                                <CheckBox Name="chkHardwareGPU" Content="Enable Hardware GPU Scheduling"/>
                            </StackPanel>
                        </GroupBox>
                        
                        <GroupBox Header="PERFORMANCE">
                            <StackPanel Margin="10">
                                <CheckBox Name="chkHighPerfPlan" Content="Enable Ultimate Performance Plan"/>
                                <CheckBox Name="chkDisableHibernation" Content="Disable Hibernation"/>
                                <CheckBox Name="chkDisableSysMain" Content="Disable SysMain"/>
                            </StackPanel>
                        </GroupBox>

                        <GroupBox Header="PRIVACY">
                            <StackPanel Margin="10">
                                <CheckBox Name="chkDisableTelemetry" Content="Disable Windows Telemetry"/>
                            </StackPanel>
                        </GroupBox>
                        
                        <Button Name="btnApplyTweaks" Content="EXECUTE_TWEAKS" Width="180" Height="40" 
                                Background="{StaticResource NeonCyan}" Foreground="{StaticResource CyberBlack}" 
                                HorizontalAlignment="Right" Margin="0,20,0,0"/>
                    </StackPanel>
                </ScrollViewer>
            </TabItem>

        </TabControl>

        <!-- Terminal -->
        <Grid Grid.Row="2" Background="Black">
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <Border BorderBrush="{StaticResource NeonCyan}" BorderThickness="0,2,0,0"/>
            
            <TextBlock Text="TERMINAL_OUTPUT >_" FontFamily="Consolas" FontWeight="Bold" Margin="10,5,0,0" Foreground="{StaticResource NeonCyan}"/>
            
            <RichTextBox Grid.Row="1" Name="txtTerminal" Background="#050505" Foreground="#00FF00" 
                         FontFamily="Consolas" FontSize="12" Margin="5"
                         VerticalScrollBarVisibility="Auto" IsReadOnly="True" BorderThickness="0">
                <FlowDocument>
                    <Paragraph>
                        <Run Text="CoreForge Web Edition Loaded..."/>
                    </Paragraph>
                </FlowDocument>
            </RichTextBox>
        </Grid>

    </Grid>
</Window>
'@

# --- Helper Functions (Embedded) ---
function Write-Log {
    param([string]$Message, [string]$Color = "White")
    
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
}

# --- Tweak Functions (Simplified) ---
function Enable-GameMode {
    Write-Log "Enabling Game Mode..." "Yellow"
    $Path = "HKCU:\Software\Microsoft\GameBar"
    if (-not (Test-Path $Path)) { New-Item $Path -Force | Out-Null }
    Set-ItemProperty -Path $Path -Name "AutoGameModeEnabled" -Value 1 -Type DWord -Force
    Write-Log "Game Mode Enabled." "Green"
}

function Optimize-NetworkForGaming {
    Write-Log "Optimizing Network..." "Yellow"
    $Path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
    if (-not (Test-Path $Path)) { New-Item $Path -Force | Out-Null }
    Set-ItemProperty -Path $Path -Name "NetworkThrottlingIndex" -Value 0xffffffff -Type DWord -Force
    Write-Log "Network Optimized." "Green"
}

function Disable-PowerThrottling {
    Write-Log "Disabling Power Throttling..." "Yellow"
    $Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling"
    if (-not (Test-Path $Path)) { New-Item $Path -Force | Out-Null }
    Set-ItemProperty -Path $Path -Name "PowerThrottlingOff" -Value 1 -Type DWord -Force
    Write-Log "Power Throttling Disabled." "Green"
}

function Set-GamePriority {
    Write-Log "Setting Game Priority..." "Yellow"
    $Path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
    if (-not (Test-Path $Path)) { New-Item $Path -Force | Out-Null }
    Set-ItemProperty -Path $Path -Name "SystemResponsiveness" -Value 0 -Type DWord -Force
    
    $Path2 = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
    if (-not (Test-Path $Path2)) { New-Item $Path2 -Force | Out-Null }
    Set-ItemProperty -Path $Path2 -Name "GPU Priority" -Value 8 -Type DWord -Force
    Set-ItemProperty -Path $Path2 -Name "Priority" -Value 6 -Type DWord -Force
    Write-Log "Game Priority Set." "Green"
}

function Disable-CPUCoreParking {
    Write-Log "Disabling CPU Core Parking..." "Yellow"
    $Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583"
    if (Test-Path $Path) {
        Set-ItemProperty -Path $Path -Name "Attributes" -Value 0 -Type DWord -Force
        Write-Log "Core Parking Disabled." "Green"
    }
    else {
        Write-Log "Core Parking path not found." "Yellow"
    }
}

function Enable-HardwareAcceleratedGPU {
    Write-Log "Enabling Hardware GPU Scheduling..." "Yellow"
    $Path = "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers"
    if (-not (Test-Path $Path)) { New-Item $Path -Force | Out-Null }
    Set-ItemProperty -Path $Path -Name "HwSchMode" -Value 2 -Type DWord -Force
    Write-Log "GPU Scheduling Enabled (Restart required)." "Green"
}

function Set-PowerPlanUltimate {
    Write-Log "Enabling Ultimate Performance..." "Yellow"
    $output = powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>&1
    if ($output -match "Power Scheme GUID: ([a-z0-9\-]+)") {
        powercfg -setactive $matches[1]
        Write-Log "Ultimate Performance Active." "Green"
    }
    else {
        Write-Log "Failed to create plan." "Red"
    }
}

function Disable-Hibernation {
    Write-Log "Disabling Hibernation..." "Yellow"
    powercfg -h off
    Write-Log "Hibernation Disabled." "Green"
}

function Disable-SysMain {
    Write-Log "Disabling SysMain..." "Yellow"
    Stop-Service "SysMain" -Force -ErrorAction SilentlyContinue
    Set-Service "SysMain" -StartupType Disabled -ErrorAction SilentlyContinue
    Write-Log "SysMain Disabled." "Green"
}

function Disable-Telemetry {
    Write-Log "Disabling Telemetry..." "Yellow"
    $Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    if (-not (Test-Path $Path)) { New-Item $Path -Force | Out-Null }
    Set-ItemProperty -Path $Path -Name "AllowTelemetry" -Value 0 -Force
    Write-Log "Telemetry Disabled." "Green"
}

# --- Main Execution ---
Add-Type -AssemblyName PresentationFramework

[xml]$XamlContent = $xaml
$XamlReader = New-Object System.Xml.XmlNodeReader $XamlContent
$Global:WPFWindow = [System.Windows.Markup.XamlReader]::Load($XamlReader)

# Find Controls
$Controls = "btnApplyTweaks", "chkEnableGameMode", "chkOptimizeNetwork", "chkDisablePowerThrottle",
"chkGamePriority", "chkDisableCoreParking", "chkHardwareGPU",
"chkHighPerfPlan", "chkDisableHibernation", "chkDisableSysMain", "chkDisableTelemetry",
"txtTerminal"

foreach ($ctrlName in $Controls) {
    $ctrl = $Global:WPFWindow.FindName($ctrlName)
    if ($ctrl) {
        Set-Variable -Name "WPF$ctrlName" -Value $ctrl -Scope Global
    }
}

# Event Handler
$Global:WPFbtnApplyTweaks.Add_Click({
        Write-Log "EXECUTING TWEAKS..." "Cyan"
    
        try {
            if ($Global:WPFchkEnableGameMode.IsChecked) { Enable-GameMode }
            if ($Global:WPFchkOptimizeNetwork.IsChecked) { Optimize-NetworkForGaming }
            if ($Global:WPFchkDisablePowerThrottle.IsChecked) { Disable-PowerThrottling }
            if ($Global:WPFchkGamePriority.IsChecked) { Set-GamePriority }
            if ($Global:WPFchkDisableCoreParking.IsChecked) { Disable-CPUCoreParking }
            if ($Global:WPFchkHardwareGPU.IsChecked) { Enable-HardwareAcceleratedGPU }
            if ($Global:WPFchkHighPerfPlan.IsChecked) { Set-PowerPlanUltimate }
            if ($Global:WPFchkDisableHibernation.IsChecked) { Disable-Hibernation }
            if ($Global:WPFchkDisableSysMain.IsChecked) { Disable-SysMain }
            if ($Global:WPFchkDisableTelemetry.IsChecked) { Disable-Telemetry }
        
            Write-Log "All tweaks applied successfully!" "Green"
        }
        catch {
            Write-Log "Error: $_" "Red"
        }
    })

Write-Log "CoreForge Web Edition Ready!" "Green"
$Global:WPFWindow.ShowDialog() | Out-Null
