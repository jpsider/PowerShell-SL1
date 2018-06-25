function Connect-SL1 {
	<#
	.Synopsis
		Connect-SL1 prepares a connection to ScienceLogic's SL1 environment.

	.Description
		Use this function to prepare your powershell session to connect to ScienceLogic's SL1. 
		This only needs to be called once every session.

	.Parameter URI
		Enter the base url of the SL1 environment
	
	.Parameter Credential
		A username and password required to connect to SL1.
	
	.Parameter Passthru
		Returns a connection status result by performing a test call.

	.Example
		$SL1Credential = Get-Credential
		Connect-SL1 -URI 'https://support.sciencelogic.com' -Credential $SL1Credential

		The first command registers a credential.
		The second command creates a connection to ScienceLogic and saves it in memory for subsequent calls to the environment.

	#>
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipeline)]
		[String]$Uri,

		[Parameter(Mandatory, Position=1)]
		[PSCredential]$Credential,

		[Parameter(Position=2)]
		[Switch]$Passthru
	)

	Process {
		$Script:SL1Defaults.APIRoot = $Uri
		$Script:SL1Defaults.Credential = $Credential
		if (!$Script:SL1Defaults.IsConnected) {
			$Result = Invoke-SL1Request Get "$($Script:SL1Defaults.APIRoot)/api/account/_self"
			if ($Result.StatusCode -ne 200) {
				Test-SL1Connected
			} else { $Script:SL1Defaults.IsConnected = $true }
		}
		if ($Passthru) {
			[pscustomobject]@{
				'IsConnected'=$Script:SL1Defaults.IsConnected
			}
		}
	}
}
