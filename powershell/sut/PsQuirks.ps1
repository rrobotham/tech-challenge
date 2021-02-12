function Find-RunningWServices {
    Get-Service -Name 'W*' |
        <#Select did not include Status. Where-object could not filter because the priperty was missing 
        by piping in that order. Another way to fix would have been to reverse where-object and sort-object 
        positions, or just eliminate the select-object entirely and use the default selected properties.
        #>
        Select-Object -Property Status,Name,DisplayName | 
        Where-object { $_.Status -eq 'Running' }
}
function Test-IsOdd {
param(
    [int]
    $Number
)
    #Test was looking for a boolean result. Originally the function was returning "$Number is odd: $isOdd".
    Set-Strictmode -Version Latest
    #When checking for odd the we need to look for a remainder (-eq 1 not -eq 0)
    $isOdd = ($Number % 2) -eq 1
    #Need to do something with this output. It can be eliminated, Out-Host, Out-Null or a few others. Depends on the needs.
    Write-Output "$Number is odd: $isOdd" | Out-Host
    #Need to get boolean value of $isOdd
    $isOdd
}
function Get-FooCount {
    Set-Strictmode -Version Latest
    function foo {
        # Do not change this inner function
        $r = @("hi")
        return $r
    }
    #Created an array from the returned results in order to count the values. 
    $foo = @(foo)
    $foo.Count
}
function Add-IntFiles {
param(
    [Parameter(Mandatory=$True)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]
    $FirstPath,
    [Parameter(Mandatory=$True)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]
    $SecondPath
)
    # Fix this without modifying the called script

    
    <#The getIntFromFile.ps1 was returning $val when called.
    This resulted in $val being changed in this function. I changed $Val in this function to $Val1 
    in order to maintain unique variables. It was calculating 4+4 instad of 12+4    
    #>
    $val1 = . $PsScriptRoot\getIntFromFile.ps1 -Path $FirstPath
    $val2 = . $PsScriptRoot\getIntFromFile.ps1 -Path $SecondPath
    $ret = $val1 + $val2
    return $ret
}