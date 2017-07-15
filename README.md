# PSToggl

| master | develop |
| ------ | ------- |
| [![Build status](https://ci.appveyor.com/api/projects/status/c6u0f4gk3ibxwa46/branch/master?svg=true)](https://ci.appveyor.com/project/Clijsters/pstoggl/branch/master) | [![Build status](https://ci.appveyor.com/api/projects/status/c6u0f4gk3ibxwa46/branch/develop?svg=true)](https://ci.appveyor.com/project/Clijsters/pstoggl/branch/develop) |

PSToggl is a PowerShell module which lets you track your time with [Toggl](https://toggl.com/) in your PowerShell.
It uses Toggl's [API v8](https://github.com/toggl/toggl_api_docs/blob/master/toggl_api.md)

## Under heavy development

**This module is under heavy development and not ready for production use (yet)**

However, I want to give you an overview of what will come and how you can contribute.

____


## Features

## Contents

 1. Features
 2. Contents
 3. Getting started
    - Installation
    - Configuration
 2. How to use
 3. License

## Getting started

### Installation

**//TODO: Attention! PSToggl is not yet published and only configurable over a json file.**

I recommend you to to use `Install-Module` to install PSToggl:

````PowerShell
#Running PowerShell as Administrator - Install globally
Install-Module PSToggl

#Without Administrator privileges - Only for the current user
Install-Module PSToggl -Scope CurrentUser
````

Alternatively, just clone this repo and import the module:

````PowerShell
git clone https://github.com/clijsters/PSToggl
Import-Module PSToggl/PSToggl/PSToggl/PSToggl.psd1 # Yeah, 4 times 
````

### Configuration

**//TODO A configuration cmdlet is not implemented yet.**

To set your Personal Access Token, create a `[gitDir]/PSToggl/config.json` with the following structure:

````json
{
    "toggl": {
        "URL": "https://www.toggl.com/api/v8/",
        "APIKey": "ffffffffffffffffffffffffffffffff",
        "Workspace": 1234567,
        "SummaryOnLoad": false
    }
}
````

## How to use

````PowerShell
PS> Get-TogglEntry
````

````PowerShell
PS> Get-TogglEntry
````

````PowerShell
PS> Get-TogglEntry
````

````PowerShell
PS> Measure-Command {mvn -U compile} | New-TogglEntry "Wasting time with coffee..."
````

### Beta Features & special use cases

````PowerShell
PS> Measure-Command {git commit} | New-TogglEntry "Writing well formatted, meaningful git commit messages" -Tags @("efficiency", "Drumherum")
````

If you have tasks, repeating with the same configuration (Tags, project, title), you probably don't want to type the whole timer properties every time.  
For this case, we use _templates_. Where the Toggl Desktop client suggests timer configurations based on your previous runned timers, PSToggl introduces templates.

Theses templates - once configured - give you the ability to quickly start a timer with a defined name, project, client, tags, ...

There are two types of templates. Full templates and configuration templates. The latter is without a title.

Tab completion based on previous entered information will also be supported to mimic the behavior of Toggl Desktop.

````PowerShell
PS> Start-TogglEntry -Template vcs
PS> git checkout master
PS> git merge dev --no-ff --no-commit
PS> vim pom.xml
PS> #[...]
PS> git add pom.xml
PS> git commit -m "Merge dev branch and increase version number"
PS> git push fork dev
PS> Invoke-Chrome -bookmark GitLab
PS> Stop-TogglEntry -PassThrough | Select Minutes
PS> #Stop-TogglEntry -PassThrough | New-JiraWorklog -Issue Proj-12
````
