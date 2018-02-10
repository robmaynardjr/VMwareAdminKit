<#
.Synopsis
   Get a list or report of all snapshots saved in a vCenter environment.
.DESCRIPTION
   Get a list or report of all snapshots saved in a vCenter environment. This is good for identifying VM's that may have too many snapshots attached or snapshots that are too old. 
.PARAMETER vCenter
    Enter the vCenter Server(s) to search for VM snapshots.
.PARAMETER OutFile
    If this flag is set, output will be saved to a report or file.
.PARAMETER OutputType
    Select the output file type. Must choose "csv", "html", or "text". $OutFile switch parameter must be set to select this parameter.
.EXAMPLE
   Coming soon.
.EXAMPLE
   Coming soon.
.NOTES
    Version 0.1
    Created by Rob Maynard Jr.
    February 9, 2018
#>
function Get-vmSnapShots
{
    [CmdletBinding()]
    [Alias("gvmss")]    
    Param
    (
        # PARAMETER SET 0 (DEFAULT)
        # Enter the vCenter Server(s) to search for VM snapshots.
        [Parameter(Mandatory=$true,
                    ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0,ParameterSetName='0')]
        [ValidateNotNullorEmpty()]

        [VMware.VimAutomation.Types.VIServer[]]
        $vCenter,

        #PARAMETER SET 1 (OUTPUT)
        # If this flag is set, output will be saved to a report or file.
        [Parameter(Mandatory=$false,
                    ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0,ParameterSetName='1')]
                   
        [switch]
        $OutFile,

        # Select the output file type. Must choose "csv", "html", or "text". $OutFile switch parameter must be set to select this parameter.
        [Parameter(Mandatory=$true,
                    ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0,ParameterSetName='1')]
        [ValidateNotNullorEmpty()]
        [ValidateSet("csv", "html", "txt")]

        [string]
        $OuputType
        
    )
    #Validate, Connect, Pull Data From Servers
    Begin
    {
        try {
            Connect-VIServer -Server $vCenter -Credential (Get-Credential) -SaveCredentials 
        }
        catch {
            throw $Error[0]
            break
        }
    }
    #Process Data
    Process
    {
    }
    #Output and Close
    End
    {
    }
}

