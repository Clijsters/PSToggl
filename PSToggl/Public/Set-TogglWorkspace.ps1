function Set-TogglWorkspace {
    [CmdletBinding()]
    [OutputType("PSToggl.Workspace")]
    param (

    )

    begin {
        $moduleFolder = Split-Path -Path $PSScriptRoot -Parent
        $ConfigFile = Join-Path -Path $moduleFolder -ChildPath 'config.json'
    }

    process {
    }

    end {
    }
}
