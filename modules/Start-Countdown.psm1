<#
.SYNOPSIS
Provide a graphical countdown if you need to pause a script for a period of time
.EXAMPLE
Start-Countdown -Seconds 30 -Message 'Please wait...'
#>

function Start-Countdown {
    [CmdletBinding()]
    param (
        [Parameter()]
        [int]$Seconds = 10,

        [Parameter()]
        [string]$Message = 'Pause for 10 seconds...'
    )

    foreach ($count in (1..$Seconds)) {
        Write-Progress -Activity $Message -Status "Waiting for $Seconds seconds, $($Seconds - $count) left" -PercentComplete (($count / $Seconds) * 100)
        Start-Sleep -Seconds 1
    }
}
