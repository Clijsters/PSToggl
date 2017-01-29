function Invoke-TogglMethod {
    param(
        # The url to call
        [Parameter(Mandatory = $true)]
        [string] $UrlSuffix,

        # The optional InputObject to post
        [Parameter(Mandatory = $false)]
        [psobject] $InputObject
    )

    [string]$auth = $APIKey + ":" + "api_token"
    [string]$authFull = "Basic " + [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($auth))

    #TODO: foreach iteration through varname array
    Write-Var UrlSuffix
    Write-Var InputObject
    Write-Var auth
    Write-Var authFull
    $headers = @{
        Authorization = $authFull
    }
    $restUri = $togglUrl + $UrlSuffix
    Write-Var headers
    Write-Var restUri
    if ($InputObject) {
        Write-Verbose "Invoking as Post"
        $answer = Invoke-RestMethod -Uri $restUri -Headers $headers -ContentType "application/json" -Method Post -Body (ConvertTo-Json $InputObject -Depth 99)
    } else {
        Write-Verbose "Invoking as Get"
        $answer = Invoke-RestMethod -Uri $restUri -Headers $headers -ContentType "application/json"
    }

    Write-Var answer
    return $answer
}
