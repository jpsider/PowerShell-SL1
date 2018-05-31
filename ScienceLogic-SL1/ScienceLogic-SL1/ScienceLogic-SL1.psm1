$SL1Defaults = [pscustomobject]@{
	APIRoot = $null
	Credential = $null
	FormatResponse = $false
	HideFilterInfo = 1
	DefaultLimit = 100
	DefaultPageSize = 500
	IgnoreSSLErrors = $false
	IsConnected = $false
}

. $PSScriptRoot\Scripts\Core.ps1
. $PSScriptRoot\Scripts\Connect.ps1
. $PSScriptRoot\Scripts\Device.ps1