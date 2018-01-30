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

    New-Item function::local:Write-Verbose -Value (
        New-Module -ScriptBlock { param($verb, $fixedName, $verbose) } -ArgumentList @((Get-Command Write-Verbose), $PSCmdlet.MyInvocation.InvocationName, $PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent)
    ).NewBoundScriptBlock{
        param($Message)
        if ($verbose) {
            & $verb -Message "=>$fixedName $Message" -Verbose
        }
        else {
            & $verb -Message "=>$fixedName $Message"
        }
    } | Write-Verbose


    [string]$auth = $TogglConfiguration.User.ApiKey + ":" + "api_token"
    [string]$authFull = "Basic " + [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($auth))

    $headers = @{
        Authorization = $authFull
    }

    #TODO: Optional parameter
    $restUri = $TogglConfiguration.Api.baseUrl + $UrlSuffix

    @(
        "APIKey",
        "UrlSuffix",
        "InputObject",
        "auth",
        "authFull",
        "headers",
        "restUri"
    ) | ForEach-Object { if (Get-Variable $_ -ErrorAction SilentlyContinue) {Write-Verbose ((Get-Variable $_).Name.PadRight(12) + (Get-Variable $_).Value)}}

    if ($InputObject) {
        Write-Verbose "`$InputObject present"
        #$body = (ConvertTo-Json $InputObject -Depth 99)
        $body = $InputObject
        if (-not $Method) { $Method = "POST" }
        Write-Verbose "`$body: $body"
        Write-Debug "Invoking $Method request on $restUri with headers $headers"
        $answer = Invoke-RestMethod -Uri $restUri -Headers $headers -ContentType "application/json" -Method $Method -Body $body
    }
    else {
        Write-Verbose "`$InputObject not present"
        if (-not $Method) { $Method = "GET" }
        Write-Debug "Invoking $Method request on $restUri with headers $headers"
        $answer = Invoke-RestMethod -Uri $restUri -Headers $headers -ContentType "application/json" -Method $Method
    }

    Write-Debug "`$answer: $answer"
    #TODO: Error handling
    return $answer
}
