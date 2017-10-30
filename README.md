<h1 align="center">
    <img src="logo.gif" style="height:70px" alt="PSToggl Logo">
    <br>
    PSToggl
    <br>
</h1>

<p align="center">
<b>A fully featured <a href="https://toggl.com/">Toggl</a> client for your PowerShell - based on <a href="https://github.com/toggl/toggl_api_docs/blob/master/toggl_api.md">Toggl's API v8</a></b>
</p>
<p align="center">
    <a href="https://ci.appveyor.com/project/Clijsters/pstoggl/branch/master">
        <img alt="Build status for master" src="https://ci.appveyor.com/api/projects/status/c6u0f4gk3ibxwa46/branch/master?svg=true&passingText=master%20-%20OK&pendingText=master%20-%20Pending&failingText=master%20-%20Failing">
    </a>
    <a href="https://ci.appveyor.com/project/Clijsters/pstoggl/branch/develop">
        <img alt="Build status for develop" src="https://ci.appveyor.com/api/projects/status/c6u0f4gk3ibxwa46/branch/develop?svg=true&passingText=develop%20-%20OK&pendingText=develop%20-%20Pending&failingText=develop%20-%20Failing">
    </a>
    <a href="https://codecov.io/gh/Clijsters/PSToggl">
        <img alt="codecov Code Coverage" src="https://codecov.io/gh/Clijsters/PSToggl/branch/develop/graph/badge.svg">
    </a>
</p>

## Under heavy development

**This module is in an early beta stadium and not ready for production use**

It is intended to become a fully featured Toggl Client purely written in PowerShell downwards compatible to PowerShell v3 (and soon also v2)

____

## Features

PSToggl perfectly integrates in your existing PowerShell environment, independent of the operating system you want to work with. It makes heavy use of PowerShells pipeline abilities and ~~is able~~ will be able to integrate with other modules like ~~PSJira~~JiraPS, PSExcel, PSHipchat and so on. It helps you to increase your productivity by providing extended reporting features, migration&sync features (Toggl -> JIRA) and a robust interactive PowerShell client.

## Contents

1. Features
2. Contents
3. Getting started
    - Installation
    - Configuration
4. How to use
5. License

## Getting started

### Installation

**//TODO: Attention! PSToggl is not yet published and only configurable over a json file.**

It's recommended to use `Install-Module` to install PSToggl:

````PowerShell
#Running PowerShell as Administrator - Install globally
Install-Module PSToggl

#Without Administrator privileges - Only for the current user
Install-Module PSToggl -Scope CurrentUser
````

Alternatively, just clone this repo and import PSToggl:

````PowerShell
git clone https://github.com/clijsters/PSToggl
Import-Module PSToggl/PSToggl/PSToggl/PSToggl.psm1 # Yeah, 4 times
````

### Configuration

**//TODO A configuration Cmdlet is not implemented yet. Will be improved soon**


To set your Personal Access Token and your default workspace (yeah I know), create a `~/.PSToggl` JSON File with the following content:
````json
{
    "APIKey": "ffffffffffffffffffffffffffffffff",
    "Workspace": 1234567
}
````
Unencrypted?!?! Yeah, this is why it's called a beta thing...

## How to use

The best way to become familiar with PSToggl is to use Get-Help
````PowerShell
PS> Get-Help about_PSJira
PS> Get-Help Start-TogglEntry
PS> # And so on
````

````PowerShell
PS> Start-TogglEntry "Getting started with PSToggl"
````

````PowerShell
PS> Get-TogglEntry -Current | Add-TogglTag "educational"
````

````PowerShell
PS> Get-TogglProject "homepage" | Get-TogglEntry | Where-Object {-not $_.billed} | Add-TogglTag "overdue"
````

````PowerShell
PS> Measure-Command {mvn -U compile} | New-TogglEntry "Wasting time with coffee..."
````

````PowerShell
PS> Measure-Command {git commit} | New-TogglEntry "Writing well formatted, meaningful git commit messages" -Tags @("efficiency", "Drumherum")
````

___

### Beta Features & special use cases

If you have tasks, repeating with the same configuration (Tags, project, title), you probably don't want to type the whole timer properties every time.  
For this case, we use _templates_. Where the Toggl Desktop client suggests timer configurations based on your previous runned timers, PSToggl introduces templates.

Theses templates - once configured - give you the ability to quickly start a timer with a defined name, project, client, tags, ...

There are two types of templates. Full templates and configuration templates. The latter is without a title.

**Tab completion** based on previous entered information will also be supported to mimic the behavior of Toggl Desktop. (And because it makes it much much faster to use Cmdlets)

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

## Test Coverage

### Current

<a href="https://codecov.io/gh/Clijsters/PSToggl"><img src="https://codecov.io/gh/Clijsters/PSToggl/branch/develop/graphs/sunburst.svg" alt="codecov test coverage sunburst"></a>

### Historical

<img src="https://codecov.io/gh/Clijsters/PSToggl/branch/develop/graphs/commits.svg" alt="codecov test coverage graph">
