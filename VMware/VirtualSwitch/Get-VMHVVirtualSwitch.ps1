#Requires -Version 4.0
# Requires -Modules VMware.PowerCLI

<#
.SYNOPSIS
    Retrieves the virtual switches

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
    https://github.com/scriptrunner/ActionPacks/tree/master/VMware/VirtualSwitch

.Parameter VIServer
    Specifies the IP address or the DNS name of the vSphere server to which you want to connect

.Parameter VICredential
    Specifies a PSCredential object that contains credentials for authenticating with the server

.Parameter ID
    Specifies the ID of the virtual switch you want to retrieve

.Parameter Name
    Specifies the name of the virtual switch you want to retrieve, is the parameter empty all virtual switches retrieved

.Parameter Datacenter
    Filters the virtual switch connected to hosts in the specified datacenter

.Parameter VM
    Specifies the virtual machine whose virtual switch you want to retrieve

.Parameter Standard
    Indicates that you want to retrieve only VirtualSwitch objects
#>

[CmdLetBinding()]
Param(
    [Parameter(Mandatory = $true,ParameterSetName = "byID")]
    [Parameter(Mandatory = $true,ParameterSetName = "byName")]
    [Parameter(Mandatory = $true,ParameterSetName = "byDatacenter")]
    [Parameter(Mandatory = $true,ParameterSetName = "byVM")]
    [string]$VIServer,
    [Parameter(Mandatory = $true,ParameterSetName = "byID")]
    [Parameter(Mandatory = $true,ParameterSetName = "byName")]
    [Parameter(Mandatory = $true,ParameterSetName = "byDatacenter")]
    [Parameter(Mandatory = $true,ParameterSetName = "byVM")]
    [pscredential]$VICredential,
    [Parameter(Mandatory = $true,ParameterSetName = "byID")]
    [string]$ID,
    [Parameter(Mandatory = $true,ParameterSetName = "byDatacenter")]
    [string]$Datacenter,
    [Parameter(Mandatory = $true,ParameterSetName = "byVM")]
    [string]$VM,
    [Parameter(ParameterSetName = "byName")]
    [string]$Name,
    [Parameter(ParameterSetName = "byID")]
    [Parameter(ParameterSetName = "byName")]
    [Parameter(ParameterSetName = "byDatacenter")]
    [Parameter(ParameterSetName = "byVM")]
    [switch]$Standard
)

Import-Module VMware.PowerCLI

try{
    $Script:vmServer = Connect-VIServer -Server $VIServer -Credential $VICredential -ErrorAction Stop
    if($PSCmdlet.ParameterSetName  -eq "byID"){
        $Script:Output = Get-VirtualSwitch -Server $Script:vmServer -ID $ID -Standard:$Standard -ErrorAction Stop | Select-Object *
    }
    elseif($PSCmdlet.ParameterSetName  -eq "byName"){
        if([System.String]::IsNullOrWhiteSpace($Name) -eq $true){
            $Script:Output = Get-VirtualSwitch -Server $Script:vmServer -Standard:$Standard -ErrorAction Stop | Select-Object *
        }
        else{
            $Script:Output = Get-VirtualSwitch -Server $Script:vmServer -Name $Name -Standard:$Standard -ErrorAction Stop | Select-Object *
        }        
    }
    elseif($PSCmdlet.ParameterSetName  -eq "byDatacenter"){
        $Script:Output = Get-VirtualSwitch -Server $Script:vmServer -Datacenter $Datacenter -Standard:$Standard -ErrorAction Stop | Select-Object *
    }
    elseif($PSCmdlet.ParameterSetName  -eq "byVM"){
        $Script:Output = Get-VirtualSwitch -Server $Script:vmServer -VM $VM  -Standard:$Standard -ErrorAction Stop | Select-Object *
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