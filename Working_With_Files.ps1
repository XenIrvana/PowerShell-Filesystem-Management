# PowerShell Script File
#
# Examples: Working with Files
#

#region Working With Path Values

# Testing for the existence of a path (file/folder)

#######!!!! Test-Path !!!!####### 

#Test for the presence of any PowerShell Script files (.ps1) at location using WIldcards
Test-Path -Path "C:\Users\A.D.Works\Documents" -Include *.ps1 

#Test for the presence of all files EXCLUDING any Windows Batch Files (.bat) at location using Wildcards
Test-Path -Path "C:\Users\A.D.Works\Documents" -Exclude *.bat

#Test whether the path specified leads to a file. In this case using the $profile variable as our path
Test-Path -Path $Profile -PathType leaf

#### Working with Registry Paths ####

#Test whether the Registry Path of the Microsoft.PowerShell Registry Key is correct on the system. If PowerShell is installed correctly, it will return '$True'
Test-Path -Path "HKLM:\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell"
# Returns True

Test-Path -Path "HKLM:\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell\ExecutionPolicy"
# Returns False

#### Test if a File is Newer/Older than Specified Date ####

#This command uses the NewerThan dynamic parameter to determine whether the "PowerShell.exe" file on the computer is newer than "July 12, 2020".
Test-Path $PSHome\pwsh.exe -NewerThan 'July 12, 2020'


### Split-Path ### 

# Split-Path will take the full path to a file and return the Parent Folder Path

Split-Path -Path "C:\Users\A.D.Works\Documents"
# Returns C:\Users\A.D.Works

# To instead return the file/folder at the END of the path use '-Leaf'

Split-Path -Path "C:\Users\A.D.Works\Documents" -Leaf
# Returns 'Documents'

### Join-Path ###

# Join-Path joins file & folder Paths together
Join-Path -Path $env:temp -ChildPath testing
# Returns: C:\Users\A.D.Works\AppData\Local\Temp\testing

### Resolve-Path ###
# Resolve-Path will give you the full path to a location. The important thing is that it will expand wildcard lookups for you. You will get an array of values if there are more than one match

Resolve-Path -Path "C:\Users\*\Documents"

# Returns: 
# Path
# ----
# C:\Users\A.D.Works\Documents
# C:\Users\SysOp\Documents
# C:\Users\Public\Documents


########## READING/WRITING TO FILES ##########

# Redirection w/ Out-File

# Create Variables to simplify examples

$Data = 'This is some dummy text.'
$Path = "C:\Users\A.D.Works\Documents"

'This is some dummy text.' | Out-File -FilePath "C:\Users\A.D.Works\Documents\Test.txt"
# OR
$Data | Out-File -FilePath "$Path\Test.txt"


# Saving text data with Add-Content
# Add-Content Appends to files

$Data | Add-Content -Path "$Path\TestFile.txt"
Get-Content -Path "$Path\TestFile.txt" 

# Create Text Data with Set-Content
# Set-Content will create and overwrite files

Set-Content -Path "$Path\NewTestFile.txt" -Value $Data

Set-Content -Path "$Path\NewTestFile.txt" -Value 'Some dummy text.'

# Reading files with Get-Content
# Get-Content is the goto command for reading data. By default, this command will read each line of the file. You end up with an array of strings. This also passes each one down the pipe nicely.
# The -Raw parameter will bring the entire contents in as a multi-line string. This also performs faster because fewer objects are getting created.

Get-Content -Path "$Path\TestFile.txt" -Raw