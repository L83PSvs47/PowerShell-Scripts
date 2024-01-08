<#
.SYNOPSIS
Get PowerShell current session variables and exclude automatic variables from the final output.
.DESCRIPTION
The function filters out the standard variables located in System.Management.Automation.SpecialVariables and a small list of other known variables and retrieves the user defined variables.
Note. ISE has two additional standard variables: $psISE and $psUnsupportedConsoleApplications.
.EXAMPLE
$a = '1'
$b = 2
$c = 3,4,5
Get-UserDefinedVariable

Name Type            Value
---- ----            -----
a    System.String   1
b    System.Int32    2
c    System.Object[] {3, 4, 5}
#>

function Get-UserDefinedVariable {
    Get-Variable |
    Where-Object {
        (@(
            'FormatEnumerationLimit',
            'MaximumAliasCount',
            'MaximumDriveCount',
            'MaximumErrorCount',
            'MaximumFunctionCount',
            'MaximumVariableCount',
            'PGHome',
            'PGSE',
            'PGUICulture',
            'PGVersionTable',
            'PROFILE',
            'PSSessionOption'
        ) -notcontains $_.name) -and (([psobject].Assembly.GetType('System.Management.Automation.SpecialVariables').GetFields('NonPublic,Static') |
                Where-Object FieldType -EQ ([string]) |
                ForEach-Object GetValue $null)) -notcontains $_.name
    } |
    Select-Object -Property @(
        'Name',
        'Value',
        @{
            n = 'Type'
            e = { $_.Value.GetType() }
        }) |
    Format-Table -Property Name, Type, Value -AutoSize
}
