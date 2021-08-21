function New-PSModuleProject
{
    <#
        .SYNOPSIS
            Generates a new PowerShell Module Project Template.

        .DESCRIPTION
            Generates a new PowerShell Script Module Project Template, with all the core components present to Publish to PS Gallery, and/or upload to GitHub.

        .PARAMETER ModuleName
            [REQUIRED:String] |Alias: "Name"|
                Specifies the name of the Module. Used for naming of Module Root Directory, as well as both the Script Module (*.psm1), and Module Manifest (*.psd1) files.

        .PARAMETER ModuleVersion
            [OPTIONAL:Version] |Alias: "Version"| -Default = '1.0.0'-
                Specifies the Version info for the newly created Module Template. Used for the 'Version' folder within the Module Root Folder, as well as in the Module Manifest.

        .PARAMETER Path
            [OPTIONAL:String] -Default = $Pwd.Path-
                Specify the Path where your Module Project Template will be created. 
                By Default it will be created in the Current Working Directory.

        .PARAMETER AddREADME
            [OPTIONAL:Switch]
                When specified, adds a 'README.md' file to the Module Project Directory. 

        .PARAMETER InitRepo
            [OPTIONAL:Switch]
                When Specified, Initializes Module Project Root Directory as a Local Git Repository.

        .EXAMPLE
            PS C:\> New-PSModuleProject -ModuleName "PS-Test-Module" -ModuleVersion 1.0.0 -Path "C:\.git\Repos\PowerShell" -AddREADME 1 -InitRepo

            (Creates the Directory Structure: C:\.git\Repos\PowerShell\PS-Test-Module\1.0.0\  &  Populates it with the following files: 'PS-Test-Module.psm1', 'PS-Test-Module.psd1', 'README.md', 'PowerShell-Script-File.ps1'. Then Initializes the ".\PS-Test-Module" Directory as a Local Git Repo.)
    #>

    [CmdletBinding()]

    param(
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [Alias("Name")]
        [String]$ModuleName,
        [Parameter(
            Mandatory = $false
        )]
        [Alias("Version")]
        [String]$ModuleVersion = '1.0.0',
        [Parameter(
            Mandatory = $false
        )]
        [String]$Path = $Pwd.Path,
        [Parameter(
            Mandatory = $false
        )]
        [Switch]$AddREADME,
        [Parameter(
            Mandatory = $false
        )]
        [Switch]$InitRepo
    )

    BEGIN
    {
        $ModuleRootDir = "$Path\$ModuleName"
        $ModuleDir = $ModuleVersion
        $ModuleContainer = "$Path\$ModuleName\$ModuleVersion"
        $PS1 = "$ModuleContainer\PowerShell-Script-File.ps1"
        $PSM1 = "$ModuleContainer\$ModuleName.psm1"
        $PSD1 = "$ModuleContainer\$ModuleName.psd1"
        $Readme = "$ModuleContainer\README.md"
    }

    PROCESS
    {
        New-Item "$ModuleContainer" -Type Directory
        
        New-Item "$PS1" -Type File
        New-Item "$PSM1" -Type File
        
        New-ModuleManifest -Path "$PSD1" -ModuleVersion $ModuleVersion

        if ($AddREADME)
        {
            New-Item "$Readme" -Type File
        }
        else 
        {
            Write-Verbose "No README.md created..."
        }

        if ($InitRepo)
        {
            Set-Location $ModuleRootDir
            git init
            Write-Verbose "$ModuleContainer Initialized as a Local Git Repository."
        }
        else
        {
            Write-Verbose "Directory NOT Initialized..."
        }
    }

    END
    {
        Write-Verbose -Message "New Script Module Project Template $ModuleName v$ModuleVersion created at: $ModuleContainer"
    }

}