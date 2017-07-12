function ConvertTo-TogglObject {
    [CmdletBinding()]
    param(
        # A PSCustomObject to convert
        [Parameter( Mandatory = $true, Position = 0, ValueFromPipeline = $true )]
        [System.Management.Automation.PSCustomObject]
        $InputObject, <#Alias?#>

        # The Object's name
        [Parameter(Mandatory = $true)]
        [ValidateSet(
            "Client",
            "Group",
            "Project",
            "ProjectUser",
            "Tag",
            "Task",
            "Entry",
            "User",
            "Workspace"
        )]
        [String]
        $ObjectName,

        # The field configuration
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty]
        [System.Management.Automation.PSCustomObject]
        $ObjectConfig
    )


    ##
    ## TODO TESTS
    ##
    process {
        foreach ($item in $InputObject) {
            $object = @{}
            if ($item.GetType().Name -eq "HashTable") {
                $input = New-Object -TypeName psobject -Property $item
            }
            else {
                $input = $item
            }

            foreach ($field in $objectConfig.Fields) {
                $inputField = $input.PSObject.Members[$field.name].Value
                if ($null -ne $inputField) {
                    $object[$field.name] = $inputField -as $field.type
                }
                else {
                    if ($null -ne $field.default) {
                        $object[$field.name] = $field.default -as $field.type
                    }
                    elseif ($field.required) {
                        throw "Property `"$($field.name)`" is required"
                    }
                }
            }

            $result = New-Object -TypeName psobject -Property $object
            $result.PSObject.TypeNames.Insert(0, "PSToggl.$ObjectName")
            foreach ($validator in $objectConfig.Validators) {
                if (-not $validator.callback.invoke($result)) {
                    Write-Debug ($validator.name + " returned false. Throwing ArgumentException with message: " + $validator.message)
                    Throw [System.ArgumentException]::new("Error validating fields: " + $validator.message)
                }
            }
            Write-Output $result
        }
    }
}
