function ConvertTo-TogglClient {
    [CmdletBinding()]
    param(
		# A (set of) HashTable or PSCustomObject to convert
        [Parameter( Mandatory = $true, Position = 0, ValueFromPipeline = $true )]
        [PSObject[]]
		$InputObject
    )

    begin {
        $fields = @(
            @{ name = "id";		required = $false;	default = $null;	type = [int]; },
			@{ name = "name";	required = $true;	default = $null;	type = [string]; },
            @{ name = "wid";	required = $true;	default = $null;	type = [int]; },
            @{ name = "notes";	required = $false;	default = $null;	type = [string]; },
            @{ name = "at";		required = $true;	default = $null;	type = [datetime]; }
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
                if ($null -ne $inputField) {
                    $object[$field.name] = $inputField
                } else {
                    if ($null -ne $field.default) {
                        $object[$field.name] = $field.default
                    } elseif ($field.required) {
                        throw "Property `"$($field.name)`" is required"
                    }
                }
            }

            $result = New-Object -TypeName psobject -Property $object
            $result.PSObject.TypeNames.Insert(0, "PSToggl.Client")
            $result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
                Write-Output $this.name
            }
            Write-Output $result
        }
    }
}
