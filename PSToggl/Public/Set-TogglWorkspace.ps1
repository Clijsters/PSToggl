function Set-TogglWorkspace {
    #FIXME: ShouldProcess would fit here
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    [OutputType("PSToggl.Workspace")]
    param (

    )

    begin {
        New-Item function::local:Write-Verbose -Value (
            New-Module -ScriptBlock { param($verb, $fixedName, $verbose) } -ArgumentList @((Get-Command Write-Verbose), $PSCmdlet.MyInvocation.InvocationName, $PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent)
        ).NewBoundScriptBlock {
            param($Message)
            if ($verbose) {
                & $verb -Message "=>$fixedName $Message" -Verbose
            } else {
               & $verb -Message "=>$fixedName $Message"
            }
        } | Write-Verbose

        #$moduleFolder = Split-Path -Path $PSScriptRoot -Parent
        #$ConfigFile = Join-Path -Path $moduleFolder -ChildPath 'config.json'
    }

    process {
    }

    end {
    }
}
