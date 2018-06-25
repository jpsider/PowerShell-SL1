Function Get-SL1Device {
	<#
	.Synopsis
		Gets a device in ScienceLogic by ID

	.Description
		The Get-SL1Device cmdlet gets a device in the ScienceLogic platform, referenced by the device ID.

	.Parameter ID
		An integer defining the ID of the ScienceLogic Device

	.Parameter Filter
		A Sciencelogic filter used to get a set of devices

	.Parameter Limit
		The amount of devices that need to be get in each batch.

	.Example
		PS C:\>Connect-SL1 -URI 'https://support.sciencelogic.com' -Credential ( Get-Credential )
		PS C:\>Get-SL1Device -ID 1

		The first command connects to the ScienceLogic platform.
		The second command gets device with ID 1

	.Example
		PS C:\>Connect-SL1 -URI 'https://support.sciencelogic.com' -Credential ( Get-Credential )
		PS C:\>Get-SL1Device -Filter 'filter.0.organization.eq=15'

		The first command connects to the ScienceLogic platform.
		The second command gets all device with for organization with id 15
	#>
	[CmdletBinding(DefaultParameterSetName='ID')]
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipeline, ParameterSetName='ID')]
		[int64]$Id,

		[Parameter(Mandatory, Position=0, ValueFromPipeline, ParameterSetName='Filter')]
		[string]$Filter,

		[Parameter(Position=1, ParameterSetName='Filter')]
		[ValidateRange(0,([int64]::MaxValue))]
		[int64]$Limit
	)

	Begin {
		Test-SL1Connected
		if ($PSCmdlet.ParameterSetName -eq 'Filter' -and $Limit -eq 0) {
			$Limit = $Script:SL1Defaults.DefaultLimit
		}
	}

	Process {
		switch ($PSCmdlet.ParameterSetName) {
			'ID' {
				$SL1Device = Invoke-SL1Request GET "$($Script:SL1Defaults.APIROOT)/api/device/$($Id)"
				switch ($SL1Device.StatusCode) {
					{ $_ -eq [system.net.httpstatuscode]::OK } { 
						$Device = ConvertFrom-Json $SL1Device.content
						ConvertTo-Device -SL1Device $Device -ID $Id
					}
					{ $_ -eq [system.net.httpstatuscode]::Forbidden } { Write-Warning "You are not authorized to get information on device with id $($Id)"}
					{ $_ -eq [System.Net.HttpStatusCode]::NotFound } { Write-Warning "Device with id $($Id) is not found in the SL1 system" }
				}
			}
			'Filter' {
				$SL1DeviceQuery = Invoke-SL1Request Get "$($Script:SL1Defaults.APIROOT)/api/device?$($Filter)&limit=$($Limit)"

				switch ($SL1Devicequery.StatusCode) {
					{ $_ -eq [system.net.httpstatuscode]::OK} {
						$Json = ConvertFrom-Json $SL1DeviceQuery.content
						if ($Json.total_matched -eq 0) {
							Write-Warning "No devices found with filter '$($Filter)'"
						} else {
							if ($Json.total_matched -eq $Json.total_returned) {
								$Devices = ConvertFrom-Json ((Invoke-SL1Request Get "$($Script:SL1Defaults.APIROOT)/api/device?$($Filter)&limit=$($Limit)&hide_filterinfo=1&extended_fetch=1").Content)
								foreach ($DeviceURI in (($Devices | Get-Member -MemberType NoteProperty).name) ) {
									ConvertTo-Device -SL1Device $Devices.$DeviceURI -ID "$( ($DeviceURI -split '/')[-1])"
								}
							} else {
								for ($i=0; $i -lt $Json.total_matched; $i += $Limit ) {
									$Devices = ConvertFrom-Json ((Invoke-SL1Request Get "$($Script:SL1Defaults.APIROOT)/api/device?$($Filter)&limit=$($Limit)&offset=$($i)&hide_filterinfo=1&extended_fetch=1").content)
								    foreach ($DeviceURI in ($Devices | Get-Member -MemberType NoteProperty).name ) {
									    ConvertTo-Device -SL1Device $Devices.$DeviceURI -ID "$( ($DeviceURI -split '/')[-1])"
								    }
								}
							}
							
						}
					}
					{ $_ -eq [system.net.httpstatuscode]::Forbidden }  { Write-Warning "You are not authorized to get information on devices"}
					{ $_ -eq [System.Net.HttpStatusCode]::NotFound } { Write-Warning "Device with id $($Id) is not found in the SL1 system" }
				}

			}
		}
	}
}