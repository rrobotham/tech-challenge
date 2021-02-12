function Print-Stuff {
param(
    [string]$Phrase
)
    #Changed single quotes to double quotes. Double quotes are needed to print the value of $Phrase.
    "$Phrase"
}
function Print-Stuff2 {
param($obj)
    #Need to remove null values from the input array. This cleans up the leading space in the output.
    $obj = $obj | Where-Object {$_}
    $obj
}
function Print-PID {
param(
    [System.Diagnostics.Process]
    $Process
)
    # Avoid string concat
    
    #Needed to expand the subexpression. The subexpression needs to be evaultated before writing the string. 
    "Hi $($Process.Id)"
}
