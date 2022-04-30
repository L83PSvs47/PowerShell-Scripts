Import-Module -Name "$PSScriptRoot\Get-DateTimeOffset"

<#
.SYNOPSIS
Recursive cleaning of directories from outdated files
.DESCRIPTION
The Get-DateTimeOffset module is required to work
.EXAMPLE
Clear-Directory 'C:\Temp' '-1d'
.EXAMPLE
Clear-Directory 'C:\Temp' '-7d' -Exclude '*.log', '*.txt' -Verbose
.EXAMPLE
Clear-Directory -Path 'C:\Temp' -Retention '-1M' -WhatIf
#>

function Clear-Directory {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [string]$Retention,

        [Parameter()]
        [array]$Exclude,

        [parameter()]
        [switch]$WhatIf
    )

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
                if ($item.LastWriteTime -lt (Get-DateTimeOffset -DateTime $(Get-Date) -Offset $Retention)) {
                    Write-Verbose "$($item.LastAccessTime) Delete:`t$($item.FullName)"
                    Remove-Item -Path $item.FullName -Force -WhatIf:$WhatIf
                }
                else {
                    Write-Verbose "$($item.LastAccessTime) Skip:`t$($item.FullName)"
                }
            }
        }
    }
}
