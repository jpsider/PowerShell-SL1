$Script:SL1Defaults = [pscustomobject]@{
	APIRoot = $null
	Credential = $null
	FormatResponse = $false
	HideFilterInfo = 1
	DefaultLimit = 100
	DefaultPageSize = 500
	IgnoreSSLErrors = $false
	IsConnected = $false
}

foreach ($File in Get-ChildItem -Path "$($PSScriptRoot)\Scripts\private" ) {
	. $File.Fullname
}

foreach ($File in Get-ChildItem -Path "$($PSScriptRoot)\Scripts\public" ) {
	. $File.Fullname
}
