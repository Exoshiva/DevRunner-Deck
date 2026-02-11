<#  <--- Mehrzeiliger Kommentar>
    ==============================================================================
    PROJEKT:  Automatisierter Projekt-Folder
    AUTOR:    FIAE Azubi L.P
    VERSION:  v2.1.0
    DATUM:    2024-06-15
    BESCHREIBUNG: 
    Dieses Skript erstellt eine vordefinierte Ordnerstruktur für 
    neue Softwareprojekte auf dem Desktop und startet VS Code.
    ==============================================================================
#>

<#
    .SYNOPSIS
    Erstellt eine Projektstruktur

    .DESCRIPTION
    Dieses Skript automatisiert das Anlegen von Verzeichnissen wie src, docs und tests.

    .EXAMPLE 
    .\ErstelleProjekt.ps1
#>

# --- START SCRIPT --- 

<#
    ==============================================================================
    1. DEFINITIONEN UND VARIABLEN
    ==============================================================================
#>


# 1.1 - Projektname Variable (wurde in 3.1 + 3.2 gesetzt)

<#
    ==============================================================================
    2. DEFINITION DER VERZEICHNISSTRUKTUR
    ==============================================================================
#>

# 2.1 Verzeichnisstruktur (Array) 
# (Liste von Elementen mit relativen Pfaden)
$Struktur = @(
    "src/modules",      # Quellcode und Module
    "src/config",       # Konfigurationsdateien
    "data/input",       # Rohdaten für das Programm
    "data/output",      # Ergebnisse/Logs
    "docs",             # Dokumentation
    "tests",            # Unit-Tests  
    ".env",             # Für Passwörter, Private-Keys etc.
    ".gitignore",       # Für Ordner die beim GitHub Push ignoriert werden sollen
    "requirements.txt"  # Um Abhängigkeiten/Bibliotheken zu installieren     
)

Write-Host ">>> Starte Erstellung fuer: $ProjektName" -ForegroundColor Cyan

<#>
    ==============================================================================
    3. ZIELPFAD UND PROJEKTNAME FESTLEGEN
    ==============================================================================
#>

# 3.1 - Abfrage des Projektnamens
$ProjektName = Read-Host "Wie soll das Projekt heissen? (z.B. MeinProjekt)"

# 3.2 - Abfrage des Speicherortes
$BasisPfadEingabe = Read-Host "Wo soll gespeichert werden? (Enter fuer C:\Projekte)"

# 3.3 - Logik für den basispfad: Falls leer, nutze Standard
if ([string]::isNullOrWhiteSpace($BasisPfadEingabe)){
    $BasisPfad = "C:\Projekte"
} else {
    $BasisPfad = $BasisPfadEingabe
}

# 3.4 - Zusammenbau des finalen Pfads (Basispfad + Projektname)
# Join-Path ist hier sehr wichtig damit die backslashes (\) korrekt gesetzt werden
$ZielPfad = Join-Path -Path $BasisPfad -ChildPath $ProjektName

# 3.5 - Prüft ob der Basispfad überhaupt existiert 
if (-not (Test-Path $BasisPfad)){
    Write-Host "Erstelle Basis-Verzeichnis: $BasisPfad" -ForegroundColor Gray
    New-Item -ItemType Directory -path $BasisPfad -Force | Out-Null
}

# 3.6 - Haupt-Projektordner erstellen
if (-not (Test-Path $ZielPfad)){
    New-Item -ItemType Directory -Path $ZielPfad -ErrorAction SilentlyContinue | Out-Null
    Write-Host "Basis-Projektstruktur erstellt unter: $ZielPfad" -ForegroundColor Green
} else{
    Write-Warning "Der ordner esistiert bereits! Bestehende Struktur wird geprueft."
}

<#
    ==============================================================================
    4. ERSTELLUNG DER VERZEICHNISSE UND DATEIEN
    ==============================================================================
#>

# 4.1 - Iteration durch die Struktur (Die Logik)
# 'foreach' ist eine Kontrollstruktur, die jedes Element im Array einzeln abarbeitet.
foreach ($Eintrag in $Struktur) {

    # 'Join-path' verbindet die Pfade sicher miteinander
    $VollstaendgerPfad = Join-Path -Path $ZielPfad -ChildPath $Eintrag

    # Prüfen ob der Eintrag eine Datei oder ein Verzeichnis ist
    if ($Eintrag -like "*.*") {
        # Datei erstellen
        New-Item -ItemType File -Path $VollstaendgerPfad -ErrorAction SilentlyContinue | Out-Null
        Write-Host " [Check] Datei erstellt: $Eintrag " -ForegroundColor Gray
        continue
    }
    # Hier erstellen wir den Unterordner
    # Durch verschachtelte Pfade (z.B. src/modules), erstellt PS automatisch alle notwendigen Zwischenebenen
    New-Item -ItemType Directory -Path $VollstaendgerPfad -ErrorAction SilentlyContinue | Out-Null

    Write-Host " [Check] Verzeichnis erstellt: $Eintrag " -ForegroundColor Gray
}

<#
    ==============================================================================
    5. FINALE DATEIEN ANLEGEN
    ==============================================================================
#>

# 5.1 - Finale Datei anlegen 
# Eine README ist der Standart-Einstiegspunkt für jeden Entwickler!
$ReadmePfad = Join-Path -path $ZielPfad -ChildPath "README.md"
$Inhalt = "# Projekt: $ProjektName`nErstellt am: $(Get-Date)"

Set-Content -Path $ReadmePfad -Value $Inhalt

Write-Host ">>> Projekt erfolgreich erstellt!" -ForegroundColor Green

<#
    ==============================================================================
    6. VS CODE AUTOMATISIERUNG
    ==============================================================================
#>
# 6.1 - VS Code starten und Projekt öffnen
Write-Host "`n>>> Projekt erstellt. Oeffne Projekt in VS Code..." -ForegroundColor Cyan
# 'code' ist der CLI-Befehl für VS Code. Der Pfad öffnet VS Code
code $ZielPfad

# --- SKRIPT ENDE --- 

<#
    ==============================================================================
    LEGENDE & BEFEHLSÜBERSICHT
    ==============================================================================

    1. VARIABLEN ($Name)
        - Container zum speichern von Daten. In Powershell sind Variablen schwach 
        typisiert, d.h. sie erkennen meist automatisch, ob sie Text (string)
        oder Zahlen (Integer) enthalten

    2. READ-HOST
        - Ermöglicht Interaktivität. Pausier die Ausführung und liest eine
        Benutzereingabe von der Konsole ein.

    3. [string]::IsNullOrWhiteSpace($Variable)
        - Eine Methode aus dem .NET-Framework. Sie Prüft extrem sicher, ob eine
        Eingabe leer ist oder nur aus Leerzeichen besteht. Wichtig für die
        Dateieingabe-Validierung

    4. JOIN-PATH
        - Der "Sicherheits-Kleber" für Pfade. Er sorgt dafür, dass zwischen Ordner A 
        und Ordner B immer die korrekte Anzahl an Backslashes (\) steht, egal
        wie der User die Eingabe getippt hat.
    
    5. TEST-PATH
        - Gibt den Boolschen Wert (True/False) zurück. Prüft ob ein Element
        im Dateisystem tatsächlich existiert. verhindert "File Not Found"-Fehler.

    6. NEW-ITEM
        - Das Universalwerkzeug zum erstellen von Dingen (Objekten). Mit -ItemTyoe Directory
        werden Ordner erstellt, mit -ItemType "File" erstellt man Dateien.
    
    7. ERRORACTION SILENTLYCONTINUE
        - Ein "Common Parameter". Er sagt Powershell: "Wenn ein Fehler auftritt
        (z.B. Ordner Existiert schon), schrei mich nicht an, sondern mach einfach weiter"
    
    8. FOREACH ($Element in $Liste)
        -   Eine Iterations-Schleife. Sie geht jedes Element einer Liste einzeln durch
        und führt den Code im Block { } dafür aus. Unverzichtbar für Massenverarbeitung.

    9. SET-CONTENT / OUT-NULL
        - Set-Content scheibt Daten in eine Datei (überschreibt bestehende).
        - Out-Null unterdrückt die Bestätigungsausgabe im Terminal, um die
        Konsole sauber zu halten

    10. EXECUTION POLICY 
        -Falls eine Meldung kommt, dass Skripte deaktiviert sind, 
        einmalig tippen: 
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    ==============================================================================
#>

