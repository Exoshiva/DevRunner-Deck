<#
.SYNOPSIS
    Web-Projekt Scaffolder
    Erstellt eine HTML/CSS/JS Grundstruktur.
#>

# 1. Parameter abfragen (Name des Projekts)
$ProjektName = Read-Host "Wie soll die Webseite heissen? (z.B. Portfolio)"

if ([string]::IsNullOrWhiteSpace($ProjektName)) {
    Write-Warning "Kein Name eingegeben. Abbruch."
    exit
}

# 2. Zielpfad definieren (Standard: C:\Projekte)
$BasisPfad = "$HOME\Projekte"
$ZielPfad = Join-Path -Path $BasisPfad -ChildPath $ProjektName

# 3. Hauptordner erstellen
if (-not (Test-Path $ZielPfad)) {
    New-Item -ItemType Directory -Path $ZielPfad -Force | Out-Null
    Write-Host " [OK] Projektordner erstellt: $ZielPfad" -ForegroundColor Cyan
} else {
    Write-Warning " [INFO] Ordner existiert bereits. Ergänze fehlende Dateien..."
}

# 4. Die Web-Struktur definieren
$OrdnerStruktur = @(
    "assets\css",
    "assets\js",
    "assets\img",
    "assets\fonts"
)

# Ordner anlegen
foreach ($Ordner in $OrdnerStruktur) {
    $Pfad = Join-Path -Path $ZielPfad -ChildPath $Ordner
    if (-not (Test-Path $Pfad)) {
        New-Item -ItemType Directory -Path $Pfad -Force | Out-Null
        Write-Host "  + Ordner: $Ordner" -ForegroundColor Green
    }
}

# 5. Dateien mit Inhalt füllen (Boilerplate)

# --- index.html ---
$HtmlInhalt = @"
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$ProjektName</title>
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
    <header>
        <h1>Willkommen bei $ProjektName</h1>
    </header>
    
    <main>
        <p>Projekt wurde automatisch erstellt.</p>
    </main>

    <script src="assets/js/app.js"></script>
</body>
</html>
"@
$HtmlPfad = Join-Path -Path $ZielPfad -ChildPath "index.html"
if (-not (Test-Path $HtmlPfad)) {
    Set-Content -Path $HtmlPfad -Value $HtmlInhalt -Encoding UTF8
    Write-Host "  + Datei: index.html (mit HTML5 Boilerplate)" -ForegroundColor Green
}

# --- style.css ---
$CssInhalt = @"
/* Styles für $ProjektName */
body {
    font-family: sans-serif;
    margin: 0;
    padding: 20px;
    background-color: #1a1a1a;
    color: #00ff41;
}
"@
$CssPfad = Join-Path -Path $ZielPfad -ChildPath "assets\css\style.css"
if (-not (Test-Path $CssPfad)) {
    Set-Content -Path $CssPfad -Value $CssInhalt -Encoding UTF8
    Write-Host "  + Datei: style.css" -ForegroundColor Green
}

# --- app.js ---
$JsInhalt = @"
console.log('System ready: $ProjektName');
"@
$JsPfad = Join-Path -Path $ZielPfad -ChildPath "assets\js\app.js"
if (-not (Test-Path $JsPfad)) {
    Set-Content -Path $JsPfad -Value $JsInhalt -Encoding UTF8
    Write-Host "  + Datei: app.js" -ForegroundColor Green
}

# 6. VS Code öffnen
Write-Host ">>> Fertig. Oeffne VS Code..." -ForegroundColor Cyan
if (Get-Command "code" -ErrorAction SilentlyContinue) {
    code $ZielPfad
}