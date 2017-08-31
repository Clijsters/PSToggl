function Invoke-TogglMethod {
    [CmdletBinding()]
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
    New-Item function::local:Write-Verbose -Value (New-Module { param($verb, $fixedName, $verbose) } (Get-Command Write-Verbose) $PSCmdlet.MyInvocation.InvocationName $PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent).NewBoundScriptBlock{
         param($Object)
         if ($verbose) {
             & $verb "[$fixedName] $Object" -Verbose
         } else {
            & $verb "[$fixedName] $Object"
         }
    } | Out-Null

    [string]$auth = $TogglConfiguration.User.ApiKey + ":" + "api_token"
    [string]$authFull = "Basic " + [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($auth))

    $headers = @{
        Authorization = $authFull
    }

    $restUri = $TogglConfiguration.Api.baseUrl + $UrlSuffix

    @(
        "APIKey",
        "UrlSuffix",
        "InputObject",
        "auth",
        "authFull",
        "headers",
        "restUri"
    ) | ForEach-Object { if (Get-Variable $_ -ErrorAction SilentlyContinue) {Write-Debug ((Get-Variable $_).Name.PadRight(12) + (Get-Variable $_).Value)}}

    if ($InputObject) {
        $json = (ConvertTo-Json $InputObject -Depth 99)
        Write-Verbose "JSON: $json"
        if (-not $Method) { $Method = "POST" }
        $answer = Invoke-RestMethod -Uri $restUri -Headers $headers -ContentType "application/json" -Method $Method -Body $json
    }
    else {
        if (-not $Method) { $Method = "GET" }
        $answer = Invoke-RestMethod -Uri $restUri -Headers $headers -ContentType "application/json" -Method $Method
    }

    Write-Verbose $answer
    #TODO: Error handling
    return $answer
}
