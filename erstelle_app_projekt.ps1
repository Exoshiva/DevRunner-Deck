<#
.SYNOPSIS
    App-Projekt Scaffolder (MVVM Pattern)
    Erstellt eine professionelle Struktur für GUI/Mobile Apps.
#>

# 1. Parameter abfragen
$ProjektName = Read-Host "Wie soll die App heissen? (z.B. FinanceApp)"

if ([string]::IsNullOrWhiteSpace($ProjektName)) {
    Write-Warning "Kein Name eingegeben. Abbruch."
    exit
}

# 2. Pfade setzen
$BasisPfad = "$HOME\Projekte"
$ZielPfad = Join-Path -Path $BasisPfad -ChildPath $ProjektName

# 3. Hauptordner erstellen
if (-not (Test-Path $ZielPfad)) {
    New-Item -ItemType Directory -Path $ZielPfad -Force | Out-Null
    Write-Host " [INIT] App-Projekt initialisiert: $ZielPfad" -ForegroundColor Cyan
}

# 4. Die MVVM-Struktur (Industriestandard)
$OrdnerStruktur = @(
    "src\Models",       # Datenstrukturen (Datenbank-Objekte)
    "src\Views",        # Die Benutzeroberfläche (XAML, Pages)
    "src\ViewModels",   # Die Logik dahinter (Verbindung View <-> Model)
    "src\Services",     # API-Aufrufe, Datenbank-Logik
    "resources\fonts",  # Schriftarten
    "resources\images", # Icons und Bilder
    "tests\UnitTests"   # Automatische Tests
)

foreach ($Ordner in $OrdnerStruktur) {
    $Pfad = Join-Path -Path $ZielPfad -ChildPath $Ordner
    if (-not (Test-Path $Pfad)) {
        New-Item -ItemType Directory -Path $Pfad -Force | Out-Null
        Write-Host "  + Layer: $Ordner" -ForegroundColor Green
    }
}

# 5. Dokumentation (README mit Architektur-Erklärung)
$ReadmeInhalt = @"
# $ProjektName
App-Architektur basierend auf MVVM.

## Struktur
- **Models**: Reine Datenobjekte.
- **Views**: UI-Komponenten (Fenster/Screens).
- **ViewModels**: Geschäftslogik und State-Management.
- **Services**: Externe Schnittstellen (API, DB).
"@
$ReadmePfad = Join-Path -Path $ZielPfad -ChildPath "README.md"
Set-Content -Path $ReadmePfad -Value $ReadmeInhalt -Encoding UTF8
Write-Host "  + Doc: README.md (MVVM Info)" -ForegroundColor Green

# 6. Konfigurations-Dummy (JSON)
$ConfigInhalt = @"
{
    "AppSettings": {
        "AppName": "$ProjektName",
        "Version": "1.0.0",
        "Theme": "Dark"
    }
}
"@
$ConfigPfad = Join-Path -Path $ZielPfad -ChildPath "appsettings.json"
Set-Content -Path $ConfigPfad -Value $ConfigInhalt -Encoding UTF8
Write-Host "  + Config: appsettings.json" -ForegroundColor Green

# 7. Abschluss
Write-Host ">>> App-Struktur bereit. Coding time!" -ForegroundColor Cyan
Start-Sleep -Milliseconds 500

if (Get-Command "code" -ErrorAction SilentlyContinue) {
    code $ZielPfad
}