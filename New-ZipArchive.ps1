function New-ZipArchive
{
    <#
        .SYNOPSIS
            Creates a new Zip Archive.

        .DESCRIPTION
            Creates a Compressed *.zip Archive from Input Directory.

        .PARAMETER InputDir
            Specify an input Directory to compress.

        .PARAMETER OutArchive
            Specify the Zip Archive filename.

        .EXAMPLE
            PS C:\> New-ZipArchive -Input "C:\lib\powershell" -OutArchive "C:\powershell.zip"

        .LINK
            .

        .NOTES
            Filename: 'New-ZipArchive.ps1'
            Version: 1.0.0
            Author: XenIrvana
    #>

    [CmdletBinding()]

    param(
        [Parameter(
            Mandatory = $true
        )]
        [Alias("In")]
        [String]$InputDir,
        [Parameter(
            Mandatory = $true
        )]
        [Alias("Out")]
        [String]$OutArchive
    )

    BEGIN
    {
        Add-Type -Assembly System.IO.Compression.FileSystem
        $CompressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
    }

    PROCESS
    {
        TRY
        {
            [System.IO.Compression.ZipFile]::CreateFromDirectory($InputDir, $OutArchive, $CompressionLevel, $false)
        }

        CATCH
        {
            Write-Error -Message "Failed to create Zip Archive." -ErrorId "COMPRESS-ARCHIVE-ERROR-01" -TargetObject $OutArchive
        }
    }

    END
    {
        Write-Verbose -Message "Operation complete!"
    }

}