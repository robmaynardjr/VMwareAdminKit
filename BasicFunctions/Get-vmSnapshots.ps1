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

    Requires: Powershell 5.0.0+
              VMware PowerCLI 6.5.0+  
#>
function Get-vmSnapShots
{
    [CmdletBinding(DefaultParameterSetName='0')]
    [Alias("gvmss")]

    Param
    (
        # PARAMETER SET 0 (DEFAULT)
        # Enter the vCenter Server(s) to search for VM snapshots.
        [Parameter(Mandatory=$true,                   
                   ValueFromPipelineByPropertyName=$true,                   
                   Position=0,ParameterSetName='0')]        

        [string[]]
        $vCenter,

        #PARAMETER SET 1 (OUTPUT)
        # If this flag is set, output will be saved to a report or file.
        [Parameter(Mandatory=$false,                    
                   ValueFromPipelineByPropertyName=$true,
                   Position=1,ParameterSetName='1')]
                   
        [switch]
        $OutFile,

        # Select the output file type. Must choose "csv", "html", or "text". $OutFile switch parameter must be set to select this parameter.
        [Parameter(Mandatory=$true,
                    ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=2,ParameterSetName='1')]
        [ValidateNotNullorEmpty()]
        [ValidateSet("csv", "html", "txt")]

        [string]
        $OuputType

        <#
        #PARAMETER SET 2 (Credentials)
        # Set Username and password to use
        [Parameter(Mandatory=$false,
                    ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=4,ParameterSetName='2')]
        #[ValidateNotNullOrEmpty()]
        
        [string]
        $User,

        [string]
        $Pass
        #>       
    )

    #Validate PowerCLI and PS versions, Connect to vCenter Servers
    Begin
    {
        Get-Module -ListAvailable VM* | Import-Module
        $PcliVer = Get-Module VMware.VimAutomation.Core | Select-Object 
        if ($PcliVer.Version.Major -ge 6 -and $PcliVer.Version.Minor -ge 5 -and $PSVersionTable.PSVersion.Major -ge 5) {

            try {
                Connect-VIServer -Server $vCenter       
            }                        
            catch {
                throw $Error[0]
                break
            }
        }        
        else {
            throw 'This cmdlet requires PowerCLI 6.5.0+ and Powershell 5.0+'
            break
        }               
    }

    #Pull VM Snapshot Data From Servers, Process Data, Report Information
    Process
    {
        $vcSnapshotArray = @()

        foreach ($v in $vCenter) {
            $snapShots = Get-VM -Server $v | Get-Snapshot
            
            foreach ($s in $snapShots) {
                $snapObj = New-Object psobject
                $snapObj | Add-Member -MemberType NoteProperty -Name VM -Value $s.VM
                $snapObj | Add-Member -MemberType NoteProperty -Name Name -Value $s.Name
                $snapObj | Add-Member -MemberType NoteProperty -Name Created -Value $s.Created
                $snapObj | Add-Member -MemberType NoteProperty -Name SizeGB -Value ($s.SizeGB)
                $vcSnapshotArray += $snapObj
            }
        }        
    }

    #Output, Display Reports and Close Connections
    End
    {
        $vcSnapshotArray
    }
}