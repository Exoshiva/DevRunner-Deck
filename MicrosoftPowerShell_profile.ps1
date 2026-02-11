# ==========================================================
# EIGENE TOOLS UND ALIASES
# ==========================================================

function Start-ProjectScaffolder {
    # Startet das Skript aus dem Tools-Ordner
    # Nutzt $HOME für Benutzerunabhängigkeit
    & "$HOME\Tools\erstelle_projekt.ps1"
}
Set-Alias -Name 'newpro' -Value Start-ProjectScaffolder