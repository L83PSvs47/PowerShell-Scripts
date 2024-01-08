<#
.SYNOPSIS
Outputs a color message to the console and a text message to the log file
.EXAMPLE
Write-Log 'Simple message...'
.EXAMPLE
Write-Log 'Info message...' 'info' 'C:\log\test.log'
.EXAMPLE
Write-Log -Level Warning -Message 'Warning message...' -LogPath 'C:\log\test.log'
#>

function Write-Log {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Message,

        [Parameter()]
        [ValidateSet('Head', 'Step', 'Info', 'Success', 'Warning', 'Error')]
        [string]$Level,

        [Parameter()]
        [System.IO.FileInfo]$LogPath
    )

    [string]$dateTime = (Get-Date).toString('dd.MM.yyyy HH:mm:ss')
    if ($LogPath) {
        if (!(Test-Path -Path $LogPath)) {
            New-Item -ItemType File -Path $LogPath -Force | Out-Null
        }
        Add-Content -Path $LogPath -Value "$dateTime`t[$($Level.ToUpper())]`t$Message"
    }

    [string]$consoleMessage = $Message -Replace "`t", ' '
    switch ($Level) {
        'Head' { Write-Host "`n$consoleMessage" -ForegroundColor DarkGray }
        'Step' { Write-Host $consoleMessage -ForegroundColor DarkCyan }
        'Info' { Write-Host $consoleMessage -ForegroundColor DarkGreen }
        'Success' { Write-Host $consoleMessage -ForegroundColor Green }
        'Warning' { Write-Host $consoleMessage -ForegroundColor Yellow }
        'Error' { Write-Host $consoleMessage -ForegroundColor Red }
        Default { Write-Host $consoleMessage }
    }
}
