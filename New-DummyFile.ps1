function New-DummyFile
{
    <#
        .SYNOPSIS
            Creates a dummy file filled with random data.

        .DESCRIPTION
            Creates a dummy file filled with random data in 1GB, 2.5GB, 5GB, 7.5GB, or 10GB sizes.

        .PARAMETER Path
            Specifies the path for created file(s). Default = Current Working Directory ($Pwd.Path)
        
        .PARAMETER Count
            Specifies the number of files to create. Default = 1

        .PARAMETER Size
            Specifies the size of each file in GB. (1GB, 2.5GB, 5GB, 7.5GB, 10GB)

        .PARAMETER BaseName
            Specifies a custom BaseName value for created file(s). Default = 'RandByteData-'

        .PARAMETER Extension
            Specifies a custom Extension for created file(s). Default = '.RAND'

        .EXAMPLE
            PS C:\> New-DummyFile

        .EXAMPLE
            PS C:\> New-DummyFile

        .EXAMPLE
            PS C:\> New-DummyFile

        .EXAMPLE
            PS C:\> New-DummyFile

        .EXAMPLE
            PS C:\> New-DummyFile

        .EXAMPLE
            PS C:\> New-DummyFile

        .INPUTS
            System.String - Path
            Int64 - Count
            System.String - Size
            System.String - BaseName
            System.String - Extension

        .OUTPUTS
            IO.File

        .LINK
            https://github.com/XenIrvana/PowerShell-Workshop

        .LINK
            https://github.com/XenIrvana/TA-Utilities

        .LINK
            https://github.com/XenIrvana/PowerShell-Filesystem-Tools

        .NOTES
            Filename: 'New-DummyFile.ps1'
            Version: 1.7.9
            Author: XenIrvana
    #>

    [CmdletBinding()]

    param(
        [Parameter(
            HelpMessage = "Specify Path for newly created file(s)."
        )]
        [String]$Path = $Pwd.Path,
        [Parameter(
            HelpMessage = "Specify the number of files to create."
        )]
        [Int64]$Count = 1,
        [Parameter(
            HelpMessage = "Specify the filesize."
        )]
        [ValidateSet('1GB', '2.5GB', '5GB', '7.5GB', '10GB')]
        [String]$Size = '1GB',
        [Parameter(
            HelpMessage = "Specify a BaseName for newly created file(s)."
        )]
        [String]$BaseName = 'RandByteData-',
        [Parameter(
            HelpMessage = "Specify an Extension for newly created file(s)."
        )]
        [String]$Extension = 'bin'
    )

    BEGIN
    {
        #Error Message Values
        $xNum = "<#>"

        #Filesize Conversion
        if ($Size -eq "1GB") {
            $SizeInBytes = "1073741824"
        }
         elseif ($Size -eq "2.5GB") {
            $SizeInBytes = "2684354560"
        }
         elseif ($Size -eq "5GB") {
            $SizeInBytes = "5368709120"
        }
         elseif ($Size -eq "7.5GB") {
            $SizeInBytes = "8053063680"
        }
         elseif ($Size -eq "10GB") {
            $SizeInBytes = "10737418240"
        }
    }

    PROCESS
    {
        if ($Count -gt "1") {
            TRY
            {
                1..$Count | % { $out = New-Object Byte[] $SizeInBytes; (New-Object Random).NextBytes($out); [IO.File]::WriteAllBytes("$Path\$BaseName$_.$Extension", $out) }
            }

            CATCH
            {
                Write-Error -Message "-[IO.File]- Failure to write Data to files: $Path\$BaseName$xNum.$Extension" -Category WriteError -TargetObject "$BaseName$xNum.$Extension" -ErrorId "DATA_WRITE_ERROR_01"            }

        }
         elseif ($Count -eq "1") {
            TRY
            {
                $Count | % { $out = New-Object Byte[] $SizeInBytes; (New-Object Random).NextBytes($out); [IO.File]::WriteAllBytes("$Path\$BaseName$_.$Extension", $out) }
            }

            CATCH
            {
                Write-Error -Message "-[IO.File]- Failure to write Data to files: $Path\$BaseName$xNum.$Extension" -Category WriteError -TargetObject "$BaseName$_.$Extension" -ErrorId "DATA_WRITE_ERROR_00"            
            }
        }
    }

    END
    {
        Write-Verbose -Message "Process Complete!"
    }
}