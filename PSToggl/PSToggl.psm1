# Credit goes to RamblingCookieMonster
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

Import-LocalizedData -BindingVariable TogglConfiguration -BaseDirectory $PSScriptRoot\Private -FileName InternalConfiguration.psd1
Foreach($import in @($Public + $Private)) {
    Try {
        . $import.fullname
    }
    Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

$formatFile = Join-Path -Path $PSScriptRoot -ChildPath 'PSJira.format.ps1xml'
Write-Verbose "Updating format data with file '$formatFile'"
Update-FormatData -AppendPath $formatFile -ErrorAction Continue
