<#
.SYNOPSIS
Gets the encoding of a text file
.DESCRIPTION
Defines a family of Unicode text encodings using Byte Order Mark (BOM).
The accuracy of this method is low, since this method only works with text files and ascii is used by default when there is no BOM.
.EXAMPLE
Get-FileEncoding 'C:\Temp\test.txt'
#>

function Get-FileEncoding {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Path
    )

    [byte[]]$bytes = (Get-Content $Path -Encoding byte -ReadCount 4 -TotalCount 4)

    if (!$bytes) { $encoding = 'UTF-8' }

    switch -regex ('{0:x2}{1:x2}{2:x2}{3:x2}' -f $bytes[0], $bytes[1], $bytes[2], $bytes[3]) {
        '^efbbbf' { $encoding = 'UTF-8' }
        '^2b2f76' { $encoding = 'UTF-7' }
        '^feff' { $encoding = 'UTF-16 (BE)' }
        '^fffe' { $encoding = 'UTF-16 (LE)' }
        '^0000feff' { $encoding = 'UTF-32 (BE)' }
        '^fffe0000' { $encoding = 'UTF-32 (LE)' }
        default { $encoding = 'ASCII' }
    }

    return $encoding
}
