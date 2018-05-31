<#

#>
Function Get-SL1Device {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory=$true, Position=0)]
		[int]$ID
	)

	Begin {
		Test-SL1Connected
	}

	Process {
		$SL1Device = Invoke-SL1Request GET "$($SL1Defaults.APIROOT)/api/device/$($ID)"
		switch ($SL1Device.StatusCode) {
			{ $_ -eq [system.net.httpstatuscode]::OK } { ConvertFrom-Json $SL1Device.content }
			{ $_ -eq [system.net.httpstatuscode]::Forbidden } { Write-Warning "You are not authorized to get information on device with id $($ID)"}
			{ $_ -eq [System.Net.HttpStatusCode]::NotFound } { Write-Warning "Device with id $($ID) is not found in the SL1 system" }
		}
	}
}
