function Invoke-TogglMethod {
    param(
        # The url to call
        [Parameter(Mandatory = $true)]
        [string]
        $UrlSuffix,

        # The optional InputObject to post
        [Parameter(Mandatory = $false)]
        [psobject]
        $InputObject,

        # Request Method, defaults to "GET" if InputObject is empty, "POST" if not
        [Parameter(Mandatory = $false)]
        [ValidateSet("GET", "POST", "PUT", "DELETE")]
        [String]
        $Method
    )

    [string]$auth = $APIKey + ":" + "api_token"
    [string]$authFull = "Basic " + [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($auth))

    $headers = @{
        Authorization = $authFull
    }

    $restUri = $togglUrl + $UrlSuffix

    # TODO: Write-Var seems to break on this way - I think because the scope changes. Clarify and fix.
    <# Just dot include write-var?
    @(
        "APIKey",
        "UrlSuffix",
        "InputObject",
        "auth",
        "authFull",
        "headers",
        "restUri"
    ) | ForEach-Object { if (Get-Variable $_ -ErrorAction SilentlyContinue) {Write-Debug ((Get-Variable $_).Name.PadRight(12) + (Get-Variable $_).Value)}}
    #>

    if ($InputObject) {
        if (-not $Method) { $Method = "POST" }
        $answer = Invoke-RestMethod -Uri $restUri -Headers $headers -ContentType "application/json" -Method $Method -Body (ConvertTo-Json $InputObject -Depth 99)
    }
    else {
        if (-not $Method) { $Method = "GET" }
        $answer = Invoke-RestMethod -Uri $restUri -Headers $headers -ContentType "application/json" -Method $Method
    }

    #TODO: Error handling

    Write-Var answer
    return $answer.data
}
