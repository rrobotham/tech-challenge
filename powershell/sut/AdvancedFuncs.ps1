Set-StrictMode -Version Latest
function Get-FullPath {
param(
    [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
    [System.IO.FileInfo]
    $File
)
#Added process block. Allows for pipeline input of array values. 
PROCESS {
    #To process each array value, a foreach is needed.
    Foreach ($f in $file) {
    Write-Output $f.FullName
    }
}
}
function Get-TextFileContent {
param(
    [Parameter(Mandatory=$True)]
    [string]
    $Path,
    [Parameter(Mandatory=$False)]
    [string]
    $FileName = '20.txt'
)
BEGIN {

    $textFilesInFolder = @(Get-ChildItem -Path $Path -Filter *.txt)
    if($textFilesInFolder.Name -notcontains $fileName) {
        #return
        <#If the filename does not exist in the folder, remove from pipeline quietly. Out-Null is a quick way to do that.
        Depending on the situation, it might be ok to leave the error in. That will allow an error to be thrown
        if the file does not exist, but the error does not look good
        #>
        Out-Null
    }
    $matchingFile = $textFilesInFolder | Where-Object { $_.Name -eq $fileName }
}
PROCESS {
     $content = $matchingFile | Get-Content
}
END {
    <#verify $content does not equal $Null. If content does not equal $Null, write-output.
    #>
    If ($Null -ne $content) {
        Write-Output "hi: $($content)"
    }
}
}