<#
    ==============================================================================
    DEVRUNNER v9.3 // MODULAR EDITION
    Features: External Script Hooks (React), Cleaned Logic Flow
    ==============================================================================
#>

# --- 1. WINDOWS API (For Window Control/Grid) ---
$Win32 = @"
using System;
using System.Runtime.InteropServices;
public class WinApi {
    [DllImport("user32.dll")]
    public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
}
"@

# Load API and assemblies separately (otherwise there are problems with WPF)
Add-Type -TypeDefinition $Win32 
Add-Type -AssemblyName PresentationFramework, System.Windows.Forms

# Username for ID 
$CurrentUser = $env:USERNAME.ToUpper()

# --- XAML DEFINITION (WPF GUI) ---
[xml]$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="DEVRUNNER" Height="780" Width="950"
        WindowStartupLocation="CenterScreen" 
        WindowStyle="None" 
        AllowsTransparency="True"
        Background="Transparent"
        UseLayoutRounding="True"
        SnapsToDevicePixels="True">

    <Window.Resources>
        <SolidColorBrush x:Key="BgDark">#05070a</SolidColorBrush>
        <SolidColorBrush x:Key="BgPanel">#0a0d14</SolidColorBrush>
        <SolidColorBrush x:Key="CyanMain">#06b6d4</SolidColorBrush>
        <SolidColorBrush x:Key="CyanDim">#0e7490</SolidColorBrush>
        <SolidColorBrush x:Key="RedAlert">#ef4444</SolidColorBrush>
        <SolidColorBrush x:Key="TextGray">#9ca3af</SolidColorBrush>
        <SolidColorBrush x:Key="BorderColor">#1f2937</SolidColorBrush>

        <Style TargetType="TextBox">
            <Setter Property="Background" Value="Black"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderBrush" Value="{StaticResource BorderColor}"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="FontFamily" Value="Consolas"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="Padding" Value="10"/>
            <Setter Property="VerticalContentAlignment" Value="Center"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TextBox">
                        <Border Background="{TemplateBinding Background}" 
                                BorderBrush="{TemplateBinding BorderBrush}" 
                                BorderThickness="{TemplateBinding BorderThickness}" 
                                CornerRadius="4">
                            <ScrollViewer x:Name="PART_ContentHost"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style TargetType="ComboBox">
            <Setter Property="Height" Value="42"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="FontFamily" Value="Consolas"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="Padding" Value="10,0,0,0"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="ComboBox">
                        <Grid>
                            <ToggleButton Name="ToggleButton" Grid.Column="2" Focusable="false"
                                          IsChecked="{Binding Path=IsDropDownOpen,Mode=TwoWay,RelativeSource={RelativeSource TemplatedParent}}"
                                          ClickMode="Press">
                                <ToggleButton.Template>
                                    <ControlTemplate>
                                        <Border Background="Black" BorderBrush="#1f2937" BorderThickness="1" CornerRadius="4">
                                            <Path Data="M 0 0 L 4 4 L 8 0 Z" Fill="#06b6d4" HorizontalAlignment="Right" Margin="0,0,15,0" VerticalAlignment="Center"/>
                                        </Border>
                                    </ControlTemplate>
                                </ToggleButton.Template>
                            </ToggleButton>
                            <ContentPresenter Name="ContentSite" IsHitTestVisible="False"  Content="{TemplateBinding SelectionBoxItem}"
                                              ContentTemplate="{TemplateBinding SelectionBoxItemTemplate}"
                                              ContentTemplateSelector="{TemplateBinding ItemTemplateSelector}"
                                              Margin="10,0,0,0" VerticalAlignment="Center" HorizontalAlignment="Left" />
                            <Popup Name="Popup" Placement="Bottom" IsOpen="{TemplateBinding IsDropDownOpen}" AllowsTransparency="True" Focusable="False" PopupAnimation="Slide">
                                <Grid Name="DropDown" SnapsToDevicePixels="True" MinWidth="{TemplateBinding ActualWidth}" MaxHeight="{TemplateBinding MaxDropDownHeight}">
                                    <Border x:Name="DropDownBorder" Background="#0a0d14" BorderThickness="1" BorderBrush="#1f2937"/>
                                    <ScrollViewer Margin="4,6,4,6" SnapsToDevicePixels="True">
                                        <StackPanel IsItemsHost="True" KeyboardNavigation.DirectionalNavigation="Contained" />
                                    </ScrollViewer>
                                </Grid>
                            </Popup>
                        </Grid>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style TargetType="ComboBoxItem">
            <Setter Property="SnapsToDevicePixels" Value="True"/>
            <Setter Property="HorizontalContentAlignment" Value="Left"/>
            <Setter Property="VerticalContentAlignment" Value="Center"/>
            <Setter Property="Background" Value="#0a0d14"/> 
            <Setter Property="Foreground" Value="White"/>    
            <Setter Property="BorderBrush" Value="#333"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Padding" Value="10"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="ComboBoxItem">
                        <Border Name="Border" Padding="2" SnapsToDevicePixels="true" Background="{TemplateBinding Background}">
                            <ContentPresenter />
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsHighlighted" Value="true">
                                <Setter TargetName="Border" Property="Background" Value="#06b6d4"/> 
                                <Setter Property="Foreground" Value="Black"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style TargetType="Button">
            <Setter Property="Background" Value="#1106b6d4"/>
            <Setter Property="Foreground" Value="{StaticResource CyanMain}"/>
            <Setter Property="BorderBrush" Value="{StaticResource CyanMain}"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="FontFamily" Value="Consolas"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border" Background="{TemplateBinding Background}" 
                                BorderBrush="{TemplateBinding BorderBrush}" 
                                BorderThickness="{TemplateBinding BorderThickness}" 
                                CornerRadius="4">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Background" Value="{StaticResource CyanMain}"/>
                                <Setter Property="Foreground" Value="Black"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="MinBtnStyle" TargetType="Button">
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Foreground" Value="{StaticResource CyanMain}"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="FontFamily" Value="Consolas"/>
            <Setter Property="FontSize" Value="14"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Padding" Value="0,-5,0,0"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Foreground" Value="White"/>
                                <Setter Property="Effect">
                                    <Setter.Value>
                                        <DropShadowEffect Color="#06b6d4" BlurRadius="10" ShadowDepth="0" Opacity="0.6"/>
                                    </Setter.Value>
                                </Setter>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="CloseBtnStyle" TargetType="Button">
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Foreground" Value="#ef4444"/> 
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="FontFamily" Value="Consolas"/>
            <Setter Property="FontSize" Value="14"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Foreground" Value="White"/> 
                                <Setter Property="Effect">
                                    <Setter.Value>
                                        <DropShadowEffect Color="White" BlurRadius="10" ShadowDepth="0" Opacity="0.6"/>
                                    </Setter.Value>
                                </Setter>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>

    <Grid Margin="10">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/> 
            <RowDefinition Height="*"/>    
        </Grid.RowDefinitions>

        <Grid Grid.Row="0" HorizontalAlignment="Left" Width="550" Height="65"
              Margin="0,0,0,-1" Panel.ZIndex="1" Name="HeaderTab" Background="Transparent">
            
            <Path Data="M 0,65 L 0,10 Q 0,0 10,0 L 475,0 Q 485,0 495,10 L 550,65 Z"
                  Stroke="{StaticResource CyanMain}" 
                  StrokeThickness="1"
                  Fill="{StaticResource BgDark}"
                  SnapsToDevicePixels="True"/>
            
            <StackPanel VerticalAlignment="Bottom" Margin="50,-25,0,6">
                <TextBlock Text="// SYSTEM_OVERRIDE" Foreground="{StaticResource CyanMain}" 
                           FontFamily="Consolas" FontSize="28" FontWeight="Bold"
                           TextOptions.TextFormattingMode="Display"/>
                
                <TextBlock Text="ADMINISTRATIVE ACCESS GRANTED // ID: $CurrentUser" 
                           Foreground="{StaticResource TextGray}" FontFamily="Consolas" FontSize="10" Margin="2,5,0,0"
                           TextOptions.TextFormattingMode="Display"/>
            </StackPanel>
        </Grid>

        <Border Grid.Row="1" 
                Background="{StaticResource BgDark}" 
                BorderBrush="{StaticResource CyanMain}" 
                BorderThickness="1" 
                CornerRadius="0,10,10,10"
                Margin="0,-1,0,0">
            
            <Border.Effect>
                 <DropShadowEffect Color="#06b6d4" BlurRadius="20" ShadowDepth="0" Opacity="0.25"/>
            </Border.Effect>

            <Grid>
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="Auto"/>
                </Grid.RowDefinitions>

                <Grid Grid.Row="0" Margin="0,15,20,0">
                    <StackPanel HorizontalAlignment="Right" Orientation="Horizontal">
                        <Button Name="BtnMin" Content="_" Style="{StaticResource MinBtnStyle}" Margin="0,0,15,5" Width="30"/>
                        <Button Name="BtnClose" Content="exit(0);" Style="{StaticResource CloseBtnStyle}" Width="100" Height="35"/>
                    </StackPanel>
                </Grid>

                <Border Grid.Row="1" Margin="40,20" Background="{StaticResource BgPanel}" BorderBrush="{StaticResource BorderColor}" BorderThickness="1" Padding="30" CornerRadius="4">
                    <StackPanel>
                        <StackPanel Orientation="Horizontal" Margin="0,0,0,25">
                            <TextBlock Text="(+)" Foreground="{StaticResource CyanMain}" FontFamily="Consolas" FontSize="18" Margin="0,0,10,0" VerticalAlignment="Center"/>
                            <TextBlock Text="INJECT NEW PROJECT DATA" Foreground="White" FontFamily="Consolas" FontSize="16" VerticalAlignment="Center"/>
                        </StackPanel>

                        <Grid Margin="0,0,0,20">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="2*"/>
                                <ColumnDefinition Width="20"/>
                                <ColumnDefinition Width="1*"/>
                            </Grid.ColumnDefinitions>

                            <StackPanel Grid.Column="0">
                                <Label Content="PROJECT IDENTIFIER (NAME)" Foreground="{StaticResource CyanDim}" FontFamily="Consolas" FontSize="10" FontWeight="Bold" Margin="0,0,0,4"/>
                                <TextBox Name="InputName" Text="NewProject_Alpha" Foreground="Gray"/>
                            </StackPanel>

                            <StackPanel Grid.Column="2">
                                <Label Content="PROJECT CLASS" Foreground="{StaticResource CyanDim}" FontFamily="Consolas" FontSize="10" FontWeight="Bold" Margin="0,0,0,4"/>
                                <ComboBox Name="InputType" SelectedIndex="0">
                                <ComboBoxItem Content="-- SELECT ARCHITECTURE --" IsEnabled="False" Foreground="#06b6d4"/>
                                <ComboBoxItem Content="--- FRONTEND ---" IsEnabled="False" Foreground="Gray"/>
                                <ComboBoxItem Content="Web App"/>
                                <ComboBoxItem Content="Mobile App"/>
                                <ComboBoxItem Content="Desktop App"/>
                                <ComboBoxItem Content="--- BACKEND ---" IsEnabled="False" Foreground="Gray"/>
                                <ComboBoxItem Content="API Service"/>
                                <ComboBoxItem Content="Cloud Function"/>
                                <ComboBoxItem Content="MICROSERVICE"/>
                                <ComboBoxItem Content="--- DEVOPS / TOOLS ---" IsEnabled="False" Foreground="Gray"/>
                                <ComboBoxItem Content="Docker Setup"/>
                                <ComboBoxItem Content="CLI Tool"/>
                                <ComboBoxItem Content="Script"/>
                                <ComboBoxItem Content="Library"/>
                            </ComboBox>
                            </StackPanel>
                        </Grid>

                        <StackPanel Margin="0,0,0,20">
                            <Label Content="DEPLOYMENT SECTOR (PATH)" Foreground="{StaticResource CyanDim}" FontFamily="Consolas" FontSize="10" FontWeight="Bold" Margin="0,0,0,4"/>
                            <TextBox Name="InputPath" Text="$HOME\Projekte"/>
                            <TextBlock Text="Paste the full local path sector." Foreground="#4b5563" FontSize="10" FontFamily="Consolas" Margin="0,5,0,0"/>
                        </StackPanel>
                        
                        <StackPanel Margin="0,0,0,25">
                            <Label Content="SYSTEM TERMINAL OUTPUT" Foreground="{StaticResource CyanDim}" FontFamily="Consolas" FontSize="10" FontWeight="Bold" Margin="0,0,0,4"/>
                            <TextBox Name="OutputLog" Height="140" TextWrapping="Wrap" IsReadOnly="True" 
                                    Background="#050505" BorderBrush="#1f2937" Foreground="#6b7280"
                                    FontFamily="Consolas" FontSize="11" Padding="10"
                                    VerticalContentAlignment="Top" 
                                    Text="Waiting for input..."/>
                        </StackPanel>

                        <Grid>
                            <Button Name="BtnStart" Content="INITIALIZE PROJECT" HorizontalAlignment="Center" Width="250" Height="50"/>
                        </Grid>
                    </StackPanel>
                </Border>

                <Grid Grid.Row="2" Height="40" Background="Transparent" Margin="40,0,40,20">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="Auto"/>
                    </Grid.ColumnDefinitions>

                    <TextBlock Text="&#169; 2026 DEVRUNNER DECK" 
                               Foreground="{StaticResource TextGray}" FontFamily="Consolas" FontSize="10" 
                               VerticalAlignment="Center" HorizontalAlignment="Left" Opacity="0.5"/>
                    
                    <Button Name="BtnFisiGrid" Grid.Column="1" Content="" 
                        Background="Transparent" Foreground="{StaticResource CyanDim}" 
                        BorderThickness="0" FontFamily="Consolas" FontSize="11" FontWeight="Bold" Cursor="Hand">
                        <Button.Template>
                            <ControlTemplate TargetType="Button">
                                <Border Background="{TemplateBinding Background}">
                                    <ContentPresenter/>
                                </Border>
                                <ControlTemplate.Triggers>
                                    <Trigger Property="IsMouseOver" Value="True">
                                        <Setter Property="Foreground" Value="{StaticResource CyanMain}"/>
                                    </Trigger>
                                </ControlTemplate.Triggers>
                            </ControlTemplate>
                        </Button.Template>
                    </Button>
                </Grid>
            </Grid>
        </Border>
    </Grid>
</Window>
"@

# --- LOADER ---
try {
    $Reader = (New-Object System.Xml.XmlNodeReader $XAML)
    $Window = [Windows.Markup.XamlReader]::Load($Reader)
} catch {
    Write-Host "FATAL UI ERROR: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.InnerException) {
        Write-Host "DETAILS: $($_.Exception.InnerException.Message)" -ForegroundColor Yellow
    }
    exit
}

# --- LOGIC HOOKS ---

# 1. Binding UI Elements
$InputType = $Window.FindName("InputType")
$InputName = $Window.FindName("InputName")
$InputPath = $Window.FindName("InputPath")
$OutputLog = $Window.FindName("OutputLog")
$BtnStart  = $Window.FindName("BtnStart")
$BtnClose  = $Window.FindName("BtnClose")
$BtnMin    = $Window.FindName("BtnMin")
$HeaderTab = $Window.FindName("HeaderTab") 

# 2. Window Moving (Drag)
$HeaderTab.Add_MouseLeftButtonDown({
    try { $Window.DragMove() } catch {}
})

# 3. Close Window and Minimize
$BtnClose.Add_Click({ $Window.Close() })
$BtnMin.Add_Click({ $Window.WindowState = "Minimized" })

# 4. PLACEHOLDER LOGIC FOR INPUT NAME
$InputName.Add_GotFocus({
    if ($InputName.Text -eq "NewProject_Alpha") {
        $InputName.Text = ""
        $InputName.Foreground = "White"
    }
})

$InputName.Add_LostFocus({
    if ([string]::IsNullOrWhiteSpace($InputName.Text)) {
        $InputName.Text = "NewProject_Alpha"
        $InputName.Foreground = "Gray"
    }
})

# 5. LOGGING FUNCTION
function Write-Log ($Text) {
    $OutputLog.AppendText("`n> $Text")
    $OutputLog.ScrollToEnd()
    [System.Windows.Forms.Application]::DoEvents()
}

<#
    ==============================================================================
    MAIN FUNCTION: CREATE PROJECTS
    ==============================================================================
#>

$BtnStart.Add_Click({
    $Name   = $InputName.Text
    $Basis  = $InputPath.Text
    
    # Get Dropdown value
    $TypRaw = $InputType.Text
    if ($InputType.SelectedItem -ne $null) {
        $TypRaw = $InputType.SelectedItem.Content
    }

    # Checks
    if ($Name -eq "NewProject_Alpha" -or [string]::IsNullOrWhiteSpace($Name)) {
        Write-Log "[ERR] IDENTIFIER MISSING. PLEASE ENTER A NAME."
        return
    }

    if ($TypRaw -match "PROJEKTART" -or [string]::IsNullOrWhiteSpace($TypRaw)) {
        Write-Log "[ERR] PROJECT CLASS MISSING. PLEASE SELECT A TYPE."
        return
    }

    # Start
    $OutputLog.Text = ">>> INITIALIZING SEQUENCE..."
    
    $Ziel = Join-Path -Path $Basis -ChildPath $Name
    
    if (-not (Test-Path $Basis)) {
        New-Item -ItemType Directory -Path $Basis -Force | Out-Null
        Write-Log "CREATED BASE SECTOR: $Basis"
    }

    if (-not (Test-Path $Ziel)) {
        New-Item -ItemType Directory -Path $Ziel -Force | Out-Null
        Write-Log "SECTOR SECURED: $Ziel"
    } else {
        Write-Log "[WARN] SECTOR ALREADY EXISTS. OVERRIDING..."
    }

<#
    ==============================================================================
    PROJECT STRUCTURE DEPLOYMENT
    Includet Template Structure Types:
    - WEB
    - APP
    - STANDARD
    - OTHER
    ==============================================================================
#>
    if ($TypRaw -match "WEB") {
        Write-Log "CLASS: WEB DEPLOYMENT"
        $Dirs = @("assets\css", "assets\js", "assets\img")
        foreach ($d in $Dirs) { New-Item -Path "$Ziel\$d" -ItemType Directory -Force | Out-Null }
        $HTML = "<!DOCTYPE html><html><head><title>$Name</title></head><body style='background:#05070a; color:cyan; font-family:monospace;'><h1>$Name // SYSTEM READY</h1></body></html>"
        Set-Content "$Ziel\index.html" $HTML -Encoding UTF8
        Write-Log "ASSETS DEPLOYED."

    } elseif ($TypRaw -match "APP") {
        Write-Log "CLASS: APP ARCHITECTURE"
        $Dirs = @("src\Models", "src\Views", "src\ViewModels", "src\Services")
        foreach ($d in $Dirs) { New-Item -Path "$Ziel\$d" -ItemType Directory -Force | Out-Null }
        Write-Log "LAYERS DEPLOYED."

    } else {
        Write-Log "CLASS: STANDARD SOFTWARE"
        $Dirs = @("src", "docs", "tests", "bin")
        foreach ($d in $Dirs) { New-Item -Path "$Ziel\$d" -ItemType Directory -Force | Out-Null }
        Write-Log "STRUCTURE DEPLOYED."
    }
<#
    ==============================================================================
    EDITOR START (VS CODE)
    ==============================================================================
#>
    Write-Log "LAUNCHING VISUAL STUDIO CODE..."
    Start-Sleep -Milliseconds 800
    
    if (Get-Command "code" -ErrorAction SilentlyContinue) {
        code $Ziel
        Write-Log "[SUCCESS] EDITOR LAUNCHED."
    } else {
        Invoke-Item $Ziel
        Write-Log "[WARN] VS CODE NOT FOUND. OPENING EXPLORER."
    }
})

<#  
    ==============================================================================
    EDITOR START (JETBRAINS)
    ==============================================================================
#>

    #--- IGNORE ---
<#
    Write-Log "LAUNCHING JETBRAINS IDE..."
    Start-Sleep -Milliseconds 800
    
    $JetBrainsPath = "C:\Program Files\JetBrains\IntelliJ IDEA Community Edition 2023.2.3\bin\idea64.exe"
    if (Test-Path $JetBrainsPath) {
        Start-Process -FilePath $JetBrainsPath -ArgumentList $Ziel
        Write-Log "[SUCCESS] JETBRAINS IDE LAUNCHED."
    } else {
        Write-Log "[WARN] JETBRAINS IDE NOT FOUND."
    }
#>

# --- START ---
$Window.ShowDialog() | Out-Null