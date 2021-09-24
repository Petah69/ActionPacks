﻿#Requires -Version 5.0
#Requires -Modules VMware.DeployAutomation

<#
    .SYNOPSIS
        Restores the state of the Auto Deploy service

    .DESCRIPTION

    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
        © ScriptRunner Software GmbH

    .COMPONENT
        Requires Module VVMware.DeployAutomation

    .LINK
        https://github.com/scriptrunner/ActionPacks/tree/master/VMware/Administration

    .Parameter VIServer
        [sr-en] IP address or the DNS name of the vSphere server to which you want to connect
        [sr-de] IP Adresse oder Name des vSphere Servers

    .Parameter VICredential
        [sr-en] PSCredential object that contains credentials for authenticating with the server
        [sr-de] Benutzerkonto um diese Aktion durchzuführen

    .Parameter ImportFilePath
        [sr-en] Import file path of restore file
        [sr-de] Dateipfad der Wiederherstellungsdatei
#>

[CmdLetBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [string]$VIServer,
    [Parameter(Mandatory = $true)]
    [pscredential]$VICredential,
    [Parameter(Mandatory = $true)]
    [string]$ImportFilePath
)

Import-Module VMware.DeployAutomation

try{
    $Script:vmServer = Connect-VIServer -Server $VIServer -Credential $VICredential -ErrorAction Stop

    $result = Import-AutoDeployState -Server $Script:vmServer -ImportFilePath $ImportFilePath -ErrorAction Stop
    if($SRXEnv) {
        $SRXEnv.ResultMessage = $result
    }
    else{
        Write-Output $result
    }
}
catch{
    throw
}
finally{    
    if($null -ne $Script:vmServer){
        Disconnect-VIServer -Server $Script:vmServer -Force -Confirm:$false
    }
}