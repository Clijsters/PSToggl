@{
    ObjectTypes = @{

        BareExample = @{
            DocUrl = "";
            Fields = @(
                @{ name = "id"; required = $false; default = $null; type = [int]; }
            );
            <#
            Commented out because it doesnt work in data sections. Thinking about alternatives...
            Validators = @(
                @{
                    name = "";
                    callback = {};
                    message = "";
                }
            );
            #>
        };

        Client = @{
            DocUrl = "";
            Fields = @(
                @{ name = "id"; required = $false; default = $null; type = [int]; },
                @{ name = "name"; required = $true; default = $null; type = [string]; },
                @{ name = "wid"; required = $true; default = $null; type = [int]; },
                @{ name = "notes"; required = $false; default = $null; type = [string]; },
                @{ name = "at"; required = $true; default = $null; type = [datetime]; }
            );
        };

        Group = @{
            DocUrl = "";
            Fields = @(
                @{ name = "id"; required = $false; default = $null; type = [int]; },
                @{ name = "name"; required = $true; default = $null; type = [string]; },
                @{ name = "wid"; required = $true; default = $null; type = [int]; },
                @{ name = "at"; required = $true; default = $null; type = [datetime]; }
            );
        };
        
        Project = @{
            DocUrl = "";
            Fields = @(
                @{ name = "id"; required = $false; default = $null; type = [int]; },
                @{ name = "name"; required = $true; default = $null; type = [string]; },
                @{ name = "wid"; required = $true; default = $null; type = [int]; },
                @{ name = "cid"; required = $false; default = $null; type = [int]; },
                @{ name = "active"; required = $true; default = $true; type = [bool]; },
                @{ name = "is_private"; required = $true; default = $true; type = [bool]; },
                @{ name = "template"; required = $false; default = $null; type = [bool]; },
                @{ name = "template_id"; required = $false; default = $null; type = [int]; }, # Check data type
                @{ name = "billable"; required = $false; default = $true; type = [string]; },
                @{ name = "auto_estimates"; required = $false; default = $false; type = [bool]; }, # Pro
                @{ name = "estimated_hours"; required = $false; default = $null; type = [int]; }, # Pro
                @{ name = "at"; required = $true; default = $null; type = [datetime]; },
                @{ name = "color"; required = $true; default = $null; type = [int]; },
                @{ name = "rate"; required = $false; default = $null; type = [float]; } # Pro
            );
        };

        ProjectUser = @{
            DocUrl = "";
            Fields = @(
                @{ name = "id";     required = $false;   default = $null;    type = [int]; },
                @{ name = "pid";   required = $true;    default = $null;    type = [int]; },
                @{ name = "uid";   required = $true;    default = $null;    type = [int]; },
                @{ name = "wid";    required = $false;    default = $null;    type = [int]; },
                @{ name = "manager";  required = $true;   default = $false;    type = [bool]; },
                @{ name = "rate";   required = $false;    default = $null;    type = [float]; }, # Pro
                @{ name = "at";     required = $false;    default = $null;    type = [datetime]; }
            );
        };

        Tag = @{
            DocUrl = "";
            Fields = @(
                @{ name = "id";     required = $false;   default = $null;    type = [int]; },
                @{ name = "wid";    required = $true;    default = $null;    type = [int]; },
                @{ name = "name";   required = $true;    default = $null;    type = [string]; }
            );
        };
    };
}
