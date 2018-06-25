Function Test-SL1Connected {
<#
	.Synopsis
		Tests connectivity to ScienceLogic SL1

	.Description
		This function verifies if the connection
#>
	if (!$Script:SL1Defaults.IsConnected) {
		throw "Connect-SL1 needs to be called first"
	}
}