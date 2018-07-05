function Connect-SL1 {
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
		if ($Script:SL1Defaults.APIRoot -ne $uri -or $Script:SL1Defaults.Credential -ne $Credential ) {
			$Script:SL1Defaults.APIRoot = $Uri
			$Script:SL1Defaults.Credential = $Credential
			$Result = Invoke-SL1Request Get "$($Script:SL1Defaults.APIRoot)/api/account/_self"
			if ($Result.StatusCode -ne 200) {
				$Script:SL1Defaults.Isconnected = $false
				throw "Unsuccessful logon!"
			} else { $Script:SL1Defaults.IsConnected = $true }

		} else {
			$Result = Invoke-SL1Request Get "$($Script:SL1Defaults.APIRoot)/api/account/_self"
			if ($Result.StatusCode -ne 200) {
				$Script:SL1Defaults.Isconnected = $false
				throw "Unsuccessful logon!"
			} else { $Script:SL1Defaults.IsConnected = $true }
		}
		if ($Passthru) {
			[pscustomobject]@{
				'IsConnected'=$Script:SL1Defaults.IsConnected
			}
		}
	}
}
