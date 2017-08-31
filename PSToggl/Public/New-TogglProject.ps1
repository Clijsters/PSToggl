function New-TogglProject {
    <#
    .Synopsis
        Creates a new Toggl Project

    .DESCRIPTION
        This function creates a new Toggl Project in a Workspace.

        If no workspace is given, it defaults to your default workspace configured in ~/.PSToggl or $TogglConfiguration (or config.json)

    .EXAMPLE
        New-TogglProject "homepage" -CustomerId 12345

        Creates a new Toggl Project for the customer with the id 12345

    .EXAMPLE
        New-TogglProject -Name "CoolStuff" | Start-TogglEntry "Organizational stuff" -Tags ("orga", "TogglMaint", "PoSh")

        Creates a new Toggl Project, passes it through the pipeline and starts an entry on it.

    .EXAMPLE
        The following is currently not supported but will be the suggested way...

        Get-JiraIssue -Query "assignee = currentUser()" | New-TogglProject -CustomerId 12345 -ErrorAction SilentlyContinue

        Creates a Toggl Project for each Jira Issue assigned to you.
        Tip: If you want to copy the model idea behind JIRA, create a timer Template for each Issue and a Project for each Project.
        This one is going to be implemented for PSJira (now JiraPS). You need it installed and configured for it to work.

    .INPUTS
        String[]
        PSToggl.Customer

    .OUTPUTS
        PSToggl.Project
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    param (
        # The name of your new project
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string] $Name, #name binding, alias summary for jiraps?

        # Identifies the projects workspace
        [Parameter(Mandatory = $false)]
        [int] $Workspace = $TogglConfiguration.User.Workspace,

        # The customer to create the project for
        [Parameter(Mandatory = $false)] #Consider defaulting to a def customer and make it optional
        [int] $CustomerId,

        # Color to identify your new project
        [Parameter(Mandatory = $false)]
        [int] $Color = 3, #Enum? Class? int? String?...

        # Color to identify your new project
        [Parameter(Mandatory = $false)]
        [int] $TemplateId
    )

    begin {
        $project = @{
            #name = $Name;
            wid = $Workspace;
            at = [datetime]::Now;
            color = $Color;
        }

        if ($CustomerId) {
            Write-Verbose "`$CustomerId was supplied, Setting to `"$CustomerId`""
            $project.cid = $CustomerId
        }

        if ($TemplateId) {
            Write-Verbose "`$TemplateId was supplied, Setting to `"$TemplateId`""
            $project.template_id = $TemplateId
        }

        Write-Verbose "Resulting template Project:"
        $project.Keys | ForEach-Object {Write-Verbose "`t$($_) is $($project[$_])"}
    }

    process {
        Write-Verbose "Processing item: `$Name=`"$Name`""
        $item = $project.PSObject.Copy()
        $item.name = $Name
        $item.Keys | ForEach-Object {Write-Verbose "`t$($_) is $($item[$_])"}
        Write-Verbose "Validating Project..."
        $item | ConvertTo-TogglProject | Write-Verbose
        Write-Debug "Before committing - Fire in the Hole!"
        $result = Invoke-TogglMethod -UrlSuffix "projects" -InputObject @{project = $item} -Method POST
        if ($result.data) {
            $result.data | ConvertTo-TogglProject
        } else {
            Throw $result
        }
    }

    end {
    }
}
