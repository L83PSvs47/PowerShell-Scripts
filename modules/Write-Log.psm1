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
        [ValidateSet('Head', 'Step', 'Info', 'Warning', 'Error')]
        [string]$Level,

        [Parameter()]
        [string]$LogPath
    )

    [string]$dateTime = (Get-Date).toString('dd.MM.yyyy HH:mm:ss')
    if ($LogPath) {
        if (!(Test-Path $LogPath)) {
            New-Item -ItemType 'File' -Path $LogPath -Force | Out-Null
        }
        Add-content $LogPath -Value "$dateTime`t[$($Level.ToUpper())]`t$Message"
    }

    [string]$consoleMessage = $Message -Replace "`t", ' '
    switch ($Level) {
        'HEAD' {
            Write-Host ''
            Write-Host "$consoleMessage" -ForegroundColor Gray
        }
        'STEP' { Write-Host $consoleMessage -ForegroundColor Cyan }
        'INFO' { Write-Host $consoleMessage -ForegroundColor Green }
        'WARNING' { Write-Host $consoleMessage -ForegroundColor Yellow }
        'ERROR' { Write-Host $consoleMessage -ForegroundColor Red }
        Default { Write-Host $consoleMessage }
    }
}
