function Get-ItemInventory
{
    <#
        .SYNOPSIS
            Returns a list of all files & folders at a specified Path and takes Inventory of them.

        .DESCRIPTION
            Returns a list of all files & folders at a specified Path and takes Inventory of them in a Logfile.

        .PARAMETER Path
            [REQUIRED:String]
            Specifies the Root Directory to take Inventory of. Default is Current Working Directory ($Pwd.Path)

        .PARAMETER Include
            [OPTIONAL:Wildcard]
            Specifies specific Item Types to include via Wildcard.

        .PARAMETER Exclude
            [OPTIONAL:Wildcard]
            Specifies specific Item Types to exclude via Wildcard.

        .PARAMETER Recurse
            [OPTIONAL:Switch]
            If specified, Inventory of the previously defined Root Directory will be taken Recursively.

        .PARAMETER DisplayResults
            [OPTIONAL:Switch]
            If specified, along with storing the resulting Item Inventory in a Logfile, the list that gets returned will also be displayed live, in the PowerShell Console Window.

        .PARAMETER GuidBaseName
            [OPTIONAL:Switch]
            If specified, the Default Inventory-Log File BaseName will be replaced with a randomly generated GUID.

        .PARAMETER OutputDirectory
            [OPTIONAL:String]
            Specifies a custom Output Path for the newly created Inventory Logfile. (ONLY Specify Path to a DIRECTORY. Do NOT include a Filename.)

        .EXAMPLE
            PS C:\> Get-ItemInventory -Path "C:\lib" -Inclue *.ps1 -Exclude *.cmd -Recurse 

        .EXAMPLE
            PS C:\> Get-ItemInventory -Path "C:\lib" -Inclue *.ps1 -Exclude *.cmd -GuidBaseName -Recurse -DisplayResults 
            
        .NOTES
            Author: Xenirvana
    #>

    [CmdletBinding()]

    param(
        [Parameter(
            Mandatory = $false,
            Position = 0
        )]
        [String]$Path = $Pwd.Path,
        [Parameter(
            Mandatory = $false
        )]
        [SupportsWildcards()]
        [String]$Include = "*.*",
        [Parameter(
            Mandatory = $false
        )]
        [SupportsWildcards()]
        [String]$Exclude = "*.exclude",
        [Parameter(
            Mandatory = $false
        )]
        [Switch]$Recurse,
        [Parameter(
            Mandatory = $false
        )]
        [Switch]$DisplayResults,
        [Parameter(
            Mandatory = $false
        )]
        [Alias("Guid")]
        [Switch]$GuidBaseName,
        [Parameter(
            Mandatory = $false
        )]
        [String]$OutputDirectory = "$env:USERPROFILE\Documents"
    )

    BEGIN
    {
        $Guid = New-Guid
        $PathSplit = (Split-Path $Path -leaf)
        $FileGuid = $Guid.ToString().ToUpper()
        $DateTime = (Get-Date -f "mm-dd-yy")
        $Timestamp = (Get-Date -f o)
        $DateFull = (Get-Date)
        $InvFileBaseName = "FilesystemAudit_Item_Inventory.log"
        $InvFileGuidName = "{" + "$FileGuid" + "}" + ".log"
        $BeginFile = "#BEGIN_FILE:"
        $FileTitle = "Log ID: " + "$InvFileBaseName"
        $FileTs = "Timestamp: " + "$Timestamp"
        $FileGuidTitle = "Log ID: " + "{" + "$FileGuid" + "}" 
        $FileHeader = "Filesystem Inventory Log for " + "USER: $env:USERNAME " + "COMPUTER: $env:COMPUTERNAME" 
        $FileSubHeaderOne = "Taken on: " + "$DateFull" + "|" + "Root Path: " + "$Path"
        $BeginInv = "Filesystem Audit of Root Directory: " + ".\$PathSplit " + "found the following items:"
        $FileFooter = "[End-Of-Audit]" 
        $FileEnd = "#END-FILE"
    }

    PROCESS
    {
        # Create Inventory Content Variable
        if ($Recurse)
        {
            $Inventory = @($Path | Get-ChildItem -Include $Include -Exclude $Exclude -Recurse)
        }
        else
        {
            $Inventory = @($Path | Get-ChildItem -Include $Include -Exclude $Exclude)
        }

        
        # Display Results to Console
        if ($DisplayResults)
        {
            $Inventory
        }

        # Output to file
        if ($GuidBaseName)
        {
            $BeginFile | Add-Content "$OutputDirectory\$InvFileGuidName"
            $FileGuidTitle | Add-Content "$OutputDirectory\$InvFileGuidName"
            $FileTs | Add-Content "$OutputDirectory\$InvFileGuidName"
            $FileHeader | Add-Content "$OutputDirectory\$InvFileGuidName"
            $FileSubHeaderOne | Add-Content "$OutputDirectory\$InvFileGuidName"
            $BeginInv | Add-Content "$OutputDirectory\$InvFileGuidName"
            $Inventory | Add-Content "$OutputDirectory\$InvFileGuidName"
            $FileFooter | Add-Content "$OutputDirectory\$InvFileGuidName"
            $FileEnd | Add-Content "$OutputDirectory\$InvFileGuidName"
        } 
        else
        {
            $BeginFile | Add-Content "$OutputDirectory\$InvFileBaseName"
            $FileGuidTitle | Add-Content "$OutputDirectory\$InvFileBaseName"
            $FileTs | Add-Content "$OutputDirectory\$InvFileBaseName"
            $FileHeader | Add-Content "$OutputDirectory\$InvFileBaseName"
            $FileSubHeaderOne | Add-Content "$OutputDirectory\$InvFileBaseName"
            $BeginInv | Add-Content "$OutputDirectory\$InvFileBaseName"
            $Inventory | Add-Content "$OutputDirectory\$InvFileBaseName"
            $FileFooter | Add-Content "$OutputDirectory\$InvFileBaseName"
            $FileEnd | Add-Content "$OutputDirectory\$InvFileBaseName"
        }

    }

    END
    {
        Write-Verbose "Inventory successfully taken of: $Path"
    }
}
