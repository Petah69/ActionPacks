#Requires -Version 4.0
# Requires -Modules VMware.PowerCLI

<#
.SYNOPSIS
    Formats a new VMFS (Virtual Machine File System) on each of the specified host disk partition

.DESCRIPTION

.NOTES
    This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
    The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
    The terms of use for ScriptRunner do not apply to this script. In particular, AppSphere AG assumes no liability for the function, 
    the use and the consequences of the use of this freely available script.
    PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of AppSphere AG.
    © AppSphere AG

.COMPONENT
    Requires Module VMware.PowerCLI

.LINK
    https://github.com/scriptrunner/ActionPacks/tree/master/VMware/Host

.Parameter VIServer
    Specifies the IP address or the DNS name of the vSphere server to which you want to connect

.Parameter VICredential
    Specifies a PSCredential object that contains credentials for authenticating with the server

.Parameter Id
    Specifies the disk partition on which you want to format a new VMFS

.Parameter VolumeName
    Specifies a name for the new VMFS
#>

[CmdLetBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [string]$VIServer,
    [Parameter(Mandatory = $true)]
    [pscredential]$VICredential,
    [Parameter(Mandatory = $true)]
    [string]$Id,
    [string]$VolumeName
)

Import-Module VMware.PowerCLI

try{
    $Script:vmServer = Connect-VIServer -Server $VIServer -Credential $VICredential -ErrorAction Stop

    if([System.String]::IsNullOrWhiteSpace($VolumeName) -eq $true){
        $Script:Output = Get-VMHostDiskPartition -Server $Script:vmServer -Id $Id `
                            | Format-VMHostDiskPartition -Confirm:$false -ErrorAction Stop | Select-Object *
    }
    else {
        $Script:Output = Get-VMHostDiskPartition -Server $Script:vmServer -Id $Id `
                        | Format-VMHostDiskPartition -Confirm:$false -VolumeName $VolumeName -ErrorAction Stop | Select-Object *
    }
    if($SRXEnv) {
        $SRXEnv.ResultMessage = $Script:Output 
    }
    else{
        Write-Output $Script:Output
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