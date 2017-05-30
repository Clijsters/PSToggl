function Set-TogglWorkspace {
    #FIXME: ShouldProcess would fit here
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
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
