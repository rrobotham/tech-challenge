function Save-XmlFile {
param(
    [Parameter(Mandatory=$True)]
    [xml]
    $Xml,
    [PArameter(Mandatory=$True)]
    [string]
    $Path
)
    #Need to get the filename from the $Path.
    $File = Split-Path -Path $Path -Leaf
    #The Test saves the file in the Temp Directory. $Path needs to be set to the correct location of the file.
    $Path = Join-Path $ENV:TEMP $File

    $xml.Save($Path)
}
function Transform-TomcatConf {
param(
    [Parameter(Mandatory=$True)]
    [xml]
    $Conf
)
    # Imagine you are following these instructions
    # on upgrading Artifactory PRIOR to 5.4.x
    # https://www.jfrog.com/confluence/display/RTF/Upgrading+Artifactory#UpgradingArtifactory-UpgradingtotheLatestVersion
    #
    # Note the instructions under the "ZIP" sub-section on the
    # tomcat server.xml
    # This function should apply the correct XML changes as required.
    # An example of the final XML is in the unit tests.

    $Service = $Conf.Server.Service
    
    $ConnCheck = ($Service.Connector | Where-Object {$_.port -contains '8040'}).count
    <#Added Out-Null to each xml modification line to make sure xml formating is preserved. If not included, output of each xml edit was added to xml
     resulting in improperly formatted xml.#>
    #Check for the existence of the connector with port = 8040
    IF ($ConnCheck -eq 0){
        #Create Connector on port 8040
        $Service.AppendChild($conf.CreateElement("Connector")) | Out-Null
        #Set the port on the new connector to 8040
        $Service.LastChild.SetAttribute("Port","8040") | Out-Null
        #Set sendReasonPhrase to True
        $Service.LastChild.SetAttribute("sendReasonPhrase","true") | Out-Null
        #Set maxThreads="50"
        $Service.LastChild.SetAttribute("maxThreads","50") | Out-Null
    }
    #Set startStopThreads="2" in engine.host
    $Service.Engine.Host.SetAttribute("startStopThreads","2") | Out-Null
    #Set sendReasonPhrase to True
    $Service.Connector[0..2].SetAttribute("sendReasonPhrase","true") | Out-Null
    #Set maxThreads="50" in case it changed.
    $Service.LastChild.SetAttribute("maxThreads","50") | Out-Null
    #Set relaxed settings on non-ajp/access connectors
    $Connectors = $Service.Connector | Where-Object { @('8040','8019') -notcontains $_.port }
    foreach ($C in $Connectors){
        $C.SetAttribute("relaxedPathChars",'[]') | Out-Null
        $C.SetAttribute("relaxedQueryChars",'[]') | Out-Null
    }

    $Conf
}