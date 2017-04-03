# Credit goes to RamblingCookieMonster
$Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

Import-LocalizedData -BindingVariable TogglConfiguration -BaseDirectory $PSScriptRoot\Private -FileName InternalConfiguration.psd1

# Add a special validator for Entry. wid is only required if pid nor tid are set
$TogglConfiguration.ObjectTypes.Entry.Validators = @(
    @{
        name = "wid validator";
        callback = {$args[0].wid -or ($args[0].pid -or $args[0].tid)};
        message = "wid is required if pid or tid are not provided";
    }
)
Foreach ($import in @($Public + $Private)) {
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
