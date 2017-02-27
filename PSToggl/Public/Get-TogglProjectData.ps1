function Get-TogglProjectData(){
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$True)
        ]
        [System.Object[]] $Project
    )

    Begin {
        $out = New-Object System.Collections.ArrayList
        $info = [System.Object]::new()
    }

    Process {
        try {
            # TODO: InputParameter
            if ($Project.id -gt 0) {
                $projectId = $Project.id
            } elseif ($Project -gt 0) {
                $projectId = $Project
            } else {
                Throw [System.ArgumentOutOfRangeException]::new("`$Project doesn't contain (or represent) a valid project id")
            }
            $info = Invoke-TogglMethod -UrlSuffix ("projects/" + $projectId)
            $out.Add($info.data) | Out-Null
        }
        #TODO
        catch [System.Net.WebException] {
            Write-Error ("Error obtainitng Project information. Last object:`n" + $Project)
            Write-Error ("Error was: " + $_.Exception.Message)
        }
    }

    End {
        $out
    }
}
