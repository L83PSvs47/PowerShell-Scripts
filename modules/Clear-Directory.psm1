Import-Module -Name "$PSScriptRoot\Get-DateTimeOffset"

<#
.SYNOPSIS
Recursive cleaning of directories from outdated files
.DESCRIPTION
The Get-DateTimeOffset module is required to work
.EXAMPLE
Clear-Directory 'C:\Temp' '-1d'
.EXAMPLE
Clear-Directory 'C:\Temp\temp.txt' '-1d'
.EXAMPLE
Clear-Directory 'C:\Temp' '-7d' -Exclude '*.log', '*.txt' -Verbose
.EXAMPLE
Clear-Directory -Path 'C:\Temp' -Retention '-1M' -WhatIf
#>

function Clear-Directory {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.IO.DirectoryInfo]$Path,

        [Parameter()]
        [string]$Retention = '-100y',

        [Parameter()]
        [array]$Exclude,

        [parameter()]
        [switch]$WhatIf
    )

    [datetime]$dateTime = Get-Date

    foreach ($item in (Get-ChildItem -Path $Path -Force)) {
        $excludeMatch = 0

        $Exclude | ForEach-Object {
            if ($item.Name -like $_) {
                $excludeMatch = $excludeMatch + 1
            }
        }

        if ($excludeMatch -eq 0) {
            if ($item.Attributes -eq 'Directory') {
                Clear-Directory -Path $item.FullName -Retention $Retention -WhatIf:$WhatIf
            }
            else {
                if ($item.LastWriteTime -lt (Get-DateTimeOffset -DateTime $dateTime -Offset $Retention)) {
                    Write-Verbose -Message "$($item.LastAccessTime) Delete:`t$($item.FullName)"
                    Remove-Item -Path $item.FullName -Force -WhatIf:$WhatIf
                }
                else {
                    Write-Verbose -Message "$($item.LastAccessTime) Skip:`t$($item.FullName)"
                }
            }
        }
    }
}
