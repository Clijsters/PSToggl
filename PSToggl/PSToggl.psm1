# Credit goes to RamblingCookieMonster
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

Foreach($import in @($Public + $Private)) {
    Try {
        . $import.fullname
    }
    Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

$formatFile = Join-Path -Path $PSScriptRoot -ChildPath 'PSToggl.format.ps1xml'
Write-Verbose "Updating format data with file '$formatFile'"
Update-FormatData -AppendPath $formatFile -ErrorAction Continue
