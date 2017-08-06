function ConvertTo-TogglObject {
    [CmdletBinding()]
    param(
        # A PSCustomObject to convert
        [Parameter( Mandatory = $true, Position = 0, ValueFromPipeline = $true )]
        [PSObject[]]
        $InputObject, <#Alias?#>

        # The field configuration
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $ObjectConfig
    )


    ##
    ## TODO TESTS
    ##
    process {
        foreach ($item in $InputObject) {
            #todo if item is empty???
            $object = @{}
            if ($item.GetType().Name -eq "HashTable") {
                $element = New-Object -TypeName psobject -Property $item
            }
            else {
                $element = $item
            }

            foreach ($field in $ObjectConfig.Fields) {
                $inputField = $element.PSObject.Members[$field.name].Value
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
            $result.PSObject.TypeNames.Insert(0, $ObjectConfig.TypeName)
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
