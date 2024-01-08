<#
.SYNOPSIS
Sends an email message
.DESCRIPTION
Uses System.Net.Mail Namespace
Allows applications to send email by using the Simple Mail Transfer Protocol (SMTP)
The SmtpClient type is obsolete on some platforms and not recommended on others
SmtpClient doesn't support many modern protocols. It is compat-only
It's great for one off emails from tools, but doesn't scale to modern requirements of the protocol
The Send-Message and the Send-MailMessage cmdlet have been deprecated
This cmdlet does not guarantee secure connections to SMTP servers
While there is no immediate replacement available in PowerShell, we recommend you do not use Send-Message and the Send-MailMessage
.EXAMPLE
Send-Message -From 'user01@example.com' -To 'user01@fabrikam.com' -Subject 'Sending the Attachment' -Message 'Test message' -Server 'smtp.example.com' -Port 587 -SSL -Login 'user01' -Password (ConvertTo-SecureString 'P@$$w0rd' -AsPlainText -Force) -Attachment 'C:\temp\test.txt'
#>

function Send-Message {
    [CmdletBinding()]
    param (
        [parameter(Mandatory)]
        [mailaddress]$From,

        [parameter(Mandatory)]
        [string[]]$To,

        [parameter(Mandatory)]
        [string]$Subject,

        [parameter(Mandatory)]
        [System.Object]$Message,

        [parameter(Mandatory)]
        [string]$Server,

        [parameter()]
        [ValidateSet('25', '465', '587')]
        [string]$Port = '25',

        [parameter()]
        [string]$Login,

        [parameter()]
        [SecureString]$Password,

        [parameter()]
        [System.IO.FileInfo]$Attachment,

        [parameter()]
        [switch]$AsHTML,

        [parameter()]
        [switch]$SSL
    )

    $email = New-Object System.Net.Mail.MailMessage
    $email.BodyEncoding = [System.Text.Encoding]::UTF8
    $email.SubjectEncoding = [System.Text.Encoding]::UTF8
    $email.From = $From.Address
    $email.To.Add($To)
    $email.Subject = $Subject
    $email.Body = $Message
    $email.IsBodyHTML = $AsHTML
    if ($Attachment) { $email.Attachments.Add($Attachment.FullName) }

    $emailClient = New-Object System.Net.Mail.SmtpClient
    $emailClient.Host = $Server
    $emailClient.Port = $Port
    $emailClient.EnableSsl = $SSL
    if ($Login) { $emailClient.Credentials = (New-Object System.Net.NetworkCredential($Login, $Password)) }

    $result = $null
    try {
        $emailClient.Send($email)
    }
    catch {
        $result = $_.Exception.Message
    }

    $email.Dispose()

    return $result
}
