# PowerShell-Scripts

Simple PowerShell scripts and modules for system administrators.

Add modules to the path specified by the environment variable `$env:PSModulePath` (the module must be stored in a directory with the same name as the base file name of the module), or import module using the command `Import-Module` (for example):

```powershell
Import-Module -Name "$PSScriptRoot\modules\ModuleName"
```
