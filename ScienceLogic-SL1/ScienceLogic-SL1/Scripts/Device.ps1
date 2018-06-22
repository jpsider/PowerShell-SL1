Function Get-SL1Device {
	<#
	.Synopsis
		Gets a device in ScienceLogic by ID

	.Description
		The Get-SL1Device cmdlet gets a device in the ScienceLogic platform, referenced by the device ID.

	.Parameter ID
		An integer defining the ID of the ScienceLogic Device

	.Example
		Connect-SL1 -URI 'https://supprt.sciencelogic.com' -Credential ( Get-Credential )
		Get-SL1Device -ID 1

		The first command connects to the ScienceLogic platform.
		The second command gets device with ID 1
	#>
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory, Position=0, ValuefromPipeline)]
		[int]$ID
	)

	Begin {
		Test-SL1Connected
	}

	Process {
		$SL1Device = Invoke-SL1Request GET "$($SL1Defaults.APIROOT)/api/device/$($ID)"
		switch ($SL1Device.StatusCode) {
			{ $_ -eq [system.net.httpstatuscode]::OK } { 
				$Device = ConvertFrom-Json $SL1Device.content 
				$Device | Add-Member -TypeName 'device'
				$Device | Add-Member -NotePropertyName 'URI' -NotePropertyValue "/api/device/$($ID)"
				$Device | Add-Member -NotePropertyName 'Company' -NotePropertyValue "$( (ConvertFrom-Json ((Invoke-SL1Request GET "$($SL1Defaults.APIROOT)$($Device.organization)" ).content)).company)"
				$Device
			}
			{ $_ -eq [system.net.httpstatuscode]::Forbidden } { Write-Warning "You are not authorized to get information on device with id $($ID)"}
			{ $_ -eq [System.Net.HttpStatusCode]::NotFound } { Write-Warning "Device with id $($ID) is not found in the SL1 system" }
		}
	}
}
