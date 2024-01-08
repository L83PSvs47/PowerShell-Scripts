<#
.SYNOPSIS
Calculating the date based on the specified offset
.DESCRIPTION
Date Time Format yyyy.MM.dd hh:mm:ss
DateTimeOffset +1M, -1M, +1d, -1d, +1h, -1h, ...
.EXAMPLE
Get-DateTimeOffset
.EXAMPLE
Get-DateTimeOffset $(Get-Date) '-10d'
.EXAMPLE
Get-DateTimeOffset -TimeOffset '+1y'
#>

function Get-DateTimeOffset {
    [CmdletBinding()]
    param (
        [Parameter()]
        [datetime]$DateTime,

        [Parameter()]
        [string]$Offset
    )

    if (!$DateTime) {
        $DateTime = Get-Date
    }

    [datetime]$result = 0
    switch ($Offset) {
        { $Offset.Contains('y') } { $result = $DateTime.AddYears([int]($Offset.Replace('y', ''))) }
        { $Offset.Contains('M') } { $result = $DateTime.AddMonths([int]($Offset.Replace('M', ''))) }
        { $Offset.Contains('d') } { $result = $DateTime.AddDays([int]($Offset.Replace('d', ''))) }
        { $Offset.Contains('h') } { $result = $DateTime.AddHours([int]($Offset.Replace('h', ''))) }
        { $Offset.Contains('m') } { $result = $DateTime.AddMinutes([int]($Offset.Replace('m', ''))) }
        { $Offset.Contains('s') } { $result = $DateTime.AddSeconds([int]($Offset.Replace('s', ''))) }
        Default { $result = $DateTime }
    }

    return $result
}
