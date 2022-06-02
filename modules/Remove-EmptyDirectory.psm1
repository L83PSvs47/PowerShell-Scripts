<#
.SYNOPSIS
Recursive deletion of empty directories
.EXAMPLE
Remove-EmptyDirectory 'C:\Temp'
.EXAMPLE
Remove-EmptyDirectory -Path 'C:\Temp' -Verbose
.EXAMPLE
Remove-EmptyDirectory -Path 'C:\Temp' -WhatIf
#>

function Remove-EmptyDirectory {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.IO.DirectoryInfo]$Path,

        [parameter()]
        [switch]$WhatIf
    )

    if (Test-Path -Path $Path -PathType Container) {
        foreach ($childDirectory in Get-ChildItem -Path $Path -Force -Directory) {
            Remove-EmptyDirectory -Path $childDirectory.FullName -WhatIf:$WhatIf
        }

        [System.Object]$childItems = Get-ChildItem -Path $Path -Force
        if ($null -eq $childItems) {
            Write-Verbose -Message "Removing empty folder $Path"
            Remove-Item -Path $Path -Recurse -Force -WhatIf:$WhatIf
        }
    }
}
