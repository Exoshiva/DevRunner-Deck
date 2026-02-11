# DevRunner 🚀

![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-%235391FE?logo=powershell&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey)

**DevRunner** ist ein PowerShell-Automatisierungstool, das eine standardisierte Projektstruktur (*Scaffolding*) für neue Softwareprojekte erstellt. Es richtet Ordner ein, erstellt notwendige Konfigurationsdateien und öffnet das Projekt direkt in VS Code.

> 🎓 **Hinweis:** Das Skript ist ausführlich kommentiert, um als Lernressource für PowerShell-Grundlagen (FIAE/Ausbildung) zu dienen.

---

## ✨ Features

* **Interaktiv:** Fragt Projektname und Speicherort ab (Standard: `C:\Projekte`).
* **Struktur:** Erstellt automatisch Verzeichnisse für Sourcecode (`src`), Tests, Dokumentation und Daten.
* **Boilerplate:** Legt leere Dateien wie `.gitignore`, `.env` und `requirements.txt` an.
* **Dokumentation:** Erstellt automatisch eine initiale `README.md` im neuen Projekt.
* **Workflow:** Öffnet das fertige Projekt sofort in Visual Studio Code.
* **Edukativ:** Enthält eine Legende und Erklärungen zu Befehlen wie `Join-Path`, `Test-Path` und `New-Item`.

## 📂 Erzeugte Struktur

Jedes neue Projekt erhält automatisch diesen Aufbau:

```text
MeinProjekt/
├── src/
│   ├── modules/
│   └── config/
├── data/
│   ├── input/
│   └── output/
├── docs/
├── tests/
├── .env
├── .gitignore
├── requirements.txt
└── README.md
```
## ⚙️ Installation & Einrichtung

Um den Befehl `newpro` dauerhaft in deiner PowerShell nutzen zu können, folge diesen Schritten:

### 1. Skript ablegen
Erstelle einen Ordner `Tools` in deinem Benutzerverzeichnis und speichere das Skript dort.
* **Pfad:** `C:\Users\DEIN_USER\Tools\erstelle_projekt.ps1`

### 2. PowerShell Profil konfigurieren
---
Öffne dein PowerShell-Profil mit folgendem Befehl:

```powershell
code $PROFILE
```
### 3. Alias erstellen
Füge dort folgenden Code hinzu, um den Alias zu erstellen:
```powershell
Set-Alias -Name 'newpro' -Value Start-ProjectScaffolder
```

### 4. Profil neu laden
Starte dein Terminal neu oder lade das Profil direkt neu:
```powershell
. $PROFILE
```

### Nutzung
Tippe einfach den Alias in dein Terminal:

```PowerShell
newpro
```
---

### Folge den Anweisungen auf dem Bildschirm:

1.  **Name:** Gib den Projektnamen ein (z.B. `WetterApp`).
2.  **Pfad:** Bestätige mit `Enter` (für Standard `C:\Projekte`) oder gib einen eigenen Pfad an.

✅ **Das Tool erstellt alles und startet VS Code automatisch.**

---

## 📝 Voraussetzungen

Damit alles reibungslos funktioniert, benötigst du:

* **PowerShell:** Version 5.1 oder neuer (PowerShell 7+ empfohlen).
* **Visual Studio Code:** Muss installiert sein (der Befehl `code` muss im `PATH` liegen).
* **Execution Policy:** Muss das Ausführen von Skripten erlauben.

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

##
⚖️ Lizenz
Dieses Projekt ist unter der MIT License lizenziert.

---