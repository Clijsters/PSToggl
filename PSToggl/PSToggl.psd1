#
# Modulmanifest für das Modul 'PSToggl'
#
# Generiert von: Clijsters
#
# Generiert am: 29.01.2017
#

@{

# Die diesem Manifest zugeordnete Skript- oder Binärmoduldatei.
RootModule = 'PSToggl.psm1'

# Die Versionsnummer dieses Moduls
ModuleVersion = '1.3'

# Unterstützte PSEditions
# CompatiblePSEditions = @()

# ID zur eindeutigen Kennzeichnung dieses Moduls
GUID = '82a4e375-faaa-4f30-ac79-068b8bb3314f'

# Autor dieses Moduls
Author = 'Dominique Clijsters'

# Unternehmen oder Hersteller dieses Moduls
CompanyName = 'Xylo IT'

# Urheberrechtserklärung für dieses Modul
Copyright = '(c) 2017 Dominique Clijsters. All rights reserved'

# Beschreibung der von diesem Modul bereitgestellten Funktionen
Description = 'PowerShell module to interact with the Toggl API'

# Die für dieses Modul mindestens erforderliche Version des Windows PowerShell-Moduls
PowerShellVersion = '5.0'

# Der Name des für dieses Modul erforderlichen Windows PowerShell-Hosts
# PowerShellHostName = ''

# Die für dieses Modul mindestens erforderliche Version des Windows PowerShell-Hosts
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# Die für dieses Modul erforderliche Prozessorarchitektur ('Keine', 'X86', 'Amd64').
# ProcessorArchitecture = ''

# Die Module, die vor dem Importieren dieses Moduls in die globale Umgebung geladen werden müssen
# RequiredModules = @()

# Die Assemblys, die vor dem Importieren dieses Moduls geladen werden müssen
# RequiredAssemblies = @()

# Die Skriptdateien (PS1-Dateien), die vor dem Importieren dieses Moduls in der Umgebung des Aufrufers ausgeführt werden.
# ScriptsToProcess = @()

# Die Typdateien (.ps1xml), die beim Importieren dieses Moduls geladen werden sollen
# TypesToProcess = @()

# Die Formatdateien (.ps1xml), die beim Importieren dieses Moduls geladen werden sollen
FormatsToProcess = 'PSToggl.Format.ps1xml'

# Die Module, die als geschachtelte Module des in 'RootModule/ModuleToProcess' angegebenen Moduls importiert werden sollen.
# NestedModules = @()

# Aus diesem Modul zu exportierende Funktionen. Um optimale Leistung zu erzielen, verwenden Sie keine Platzhalter und löschen den Eintrag nicht. Verwenden Sie ein leeres Array, wenn keine zu exportierenden Funktionen vorhanden sind.
FunctionsToExport = @(
    'Get-TogglClient',
    'Get-TogglEntry',
    'Get-TogglProject',
    'Get-TogglTag',
    'New-TogglProject',
    'Start-TogglEntry',
    'Write-RunningTogglEntry'
)

# Aus diesem Modul zu exportierende Cmdlets. Um optimale Leistung zu erzielen, verwenden Sie keine Platzhalter und löschen den Eintrag nicht. Verwenden Sie ein leeres Array, wenn keine zu exportierenden Cmdlets vorhanden sind.
CmdletsToExport = @()

# Die aus diesem Modul zu exportierenden Variablen
# VariablesToExport = '*'

# Aus diesem Modul zu exportierende Aliase. Um optimale Leistung zu erzielen, verwenden Sie keine Platzhalter und löschen den Eintrag nicht. Verwenden Sie ein leeres Array, wenn keine zu exportierenden Aliase vorhanden sind.
AliasesToExport = @()

# Aus diesem Modul zu exportierende DSC-Ressourcen
# DscResourcesToExport = @()

# Liste aller Module in diesem Modulpaket
# ModuleList = @()

# Liste aller Dateien in diesem Modulpaket
# FileList = @()

# Die privaten Daten, die an das in 'RootModule/ModuleToProcess' angegebene Modul übergeben werden sollen. Diese können auch eine PSData-Hashtabelle mit zusätzlichen von PowerShell verwendeten Modulmetadaten enthalten.
PrivateData = @{

    PSData = @{

        # 'Tags' wurde auf das Modul angewendet und unterstützt die Modulermittlung in Onlinekatalogen.
        Tags = @('Toggl', 'Tracking', 'Productivity')

        # Eine URL zur Lizenz für dieses Modul.
        LicenseUri = 'https://github.com/Clijsters/PSToggl/blob/master/LICENSE'

        # Eine URL zur Hauptwebsite für dieses Projekt.
        ProjectUri = 'https://github.com/Clijsters/PSToggl'

        # Eine URL zu einem Symbol, das das Modul darstellt.
        IconUri = 'https://github.com/Clijsters/PSToggl/raw/develop/logo.gif'

        # 'ReleaseNotes' des Moduls
        # ReleaseNotes = ''

    } # Ende der PSData-Hashtabelle

} # Ende der PrivateData-Hashtabelle

# HelpInfo-URI dieses Moduls
# HelpInfoURI = ''

# Standardpräfix für Befehle, die aus diesem Modul exportiert werden. Das Standardpräfix kann mit 'Import-Module -Prefix' überschrieben werden.
# DefaultCommandPrefix = ''

}

