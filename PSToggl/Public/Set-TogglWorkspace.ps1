function Set-TogglWorkspace {
	[CmdletBinding()]
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
