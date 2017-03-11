function ConvertTo-TogglProject {

    [CmdletBinding()]
    param(
        [Parameter(
			Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
		)]
        [PSObject[]] $InputObject
    )

    begin {
        $fields = @(
            @{ name = "name";		required = $true;	default = $null;	type = [string]; },
            @{ name = "wid";		required = $true;	default = $null;	type = [int]; },
            @{ name = "cid";		required = $false;	default = $null;	type = [int]; },
            @{ name = "active";		required = $true;	default = $true;	type = [bool]; },
            @{ name = "isPrivate";	required = $true;	default = $true;	type = [bool]; },
            @{ name = "template";	required = $false;	default = $null;	type = [bool]; },
            @{ name = "templateId";	required = $false;	default = $null;	type = [int]; }, # Check data type
            @{ name = "billable";	required = $false;	default = $true;	type = [string]; },
            @{ name = "autoEstimates";	required = $false;	default = $false;	type = [bool]; }, # pro
            @{ name = "estimatedHours";	required = $false;	default = $null;	type = [int]; }, # Pro
            @{ name = "at";		required = $true;	default = $null;	type = [datetime]; },
            @{ name = "color";	required = $true;	default = $null;	type = [int]; },
            @{ name = "rate";	required = $false;	default = $null;	type = [float]; } # Pro
        )
    }

    process {
        foreach ($item in $InputObject) {
            $object = @{}
            if ($item.GetType().Name -eq "HashTable") {
                $input = New-Object -TypeName psobject -Property $item
            } else {
                $input = $item
            }

            foreach ($field in $fields) {
                $inputField = $input.PSObject.Members[$field.name].Value
                if ($inputField -ne $null) {
                    $object[$field.name] = $inputField
                } else {
                    if ($field.default -ne $null) {
                        $object[$field.name] = $field.default
                    } elseif ($field.required) {
                        throw "Property `"$($field.name)`" is required"
                    }
                }
            }

            $result = New-Object -TypeName psobject -Property $object
            $result.PSObject.TypeNames.Insert(0, "PSToggl.Project")
            $result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
                Write-Output $this.name
            }
            Write-Output $result
        }
    }d
}
