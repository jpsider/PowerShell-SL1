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
	[CmdletBinding(DefaultParameterSetName='ID')]
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipeline, ParameterSetName='ID')]
		[int64]$ID,

		[Parameter(Mandatory, Position=0, ValueFromPipeline, ParameterSetName='Filter')]
		[string]$Filter,

		[Parameter(Position=1, ParameterSetName='Filter')]
		[ValidateRange(0,([int64]::MaxValue))]
		[int64]$Limit = $SL1Defaults.DefaultLimit
	)

	Begin {
		Test-SL1Connected
		#if ($PSCmdlet.ParameterSetName -eq 'Filter' -and $Limit -eq 0) {
		#	$Limit = 
		#}
	}

	Process {
		switch ($PSCmdlet.ParameterSetName) {
			'ID' {
				$SL1Device = Invoke-SL1Request GET "$($SL1Defaults.APIROOT)/api/device/$($ID)"
				switch ($SL1Device.StatusCode) {
					{ $_ -eq [system.net.httpstatuscode]::OK } { 
						$Device = ConvertFrom-Json $SL1Device.content
						ConvertTo-Device -SL1Device $Device -ID $ID
					}
					{ $_ -eq [system.net.httpstatuscode]::Forbidden } { Write-Warning "You are not authorized to get information on device with id $($ID)"}
					{ $_ -eq [System.Net.HttpStatusCode]::NotFound } { Write-Warning "Device with id $($ID) is not found in the SL1 system" }
				}
			}
			'Filter' {
				$SL1DeviceQuery = Invoke-SL1Request Get "$($SL1Defaults.APIROOT)/api/device?$($Filter)&limit=$($Limit)"

				switch ($SL1Devicequery.StatusCode) {
					{ $_ -eq [system.net.httpstatuscode]::OK} {
						$json = ConvertFrom-Json $SL1DeviceQuery.content
						if ($json.total_matched -eq 0) {
							Write-Warning "No devices found with filter $($Filter)"
						} else {
							if ($json.total_matched -eq $json.total_returned) {
								Write-Verbose "total_matched equals total_returned"
								$Devices = ConvertFrom-Json ((Invoke-SL1Request Get "$($SL1Defaults.APIROOT)/api/device?$($Filter)&limit=$($Limit)&hide_filterinfo=1&extended_fetch=1").Content)
								foreach ($DeviceURI in (($Devices | Get-Member -MemberType NoteProperty).name) ) {
									ConvertTo-Device -SL1Device $Devices.$DeviceURI -ID "$( ($DeviceURI -split '/')[-1])"
								}
							} else {
								Write-Verbose "total_matched is more than total_returned"
								for ($i=0; $i -lt $json.total_matched; $i += $Limit ) {
									$Devices = ConvertFrom-Json ((Invoke-SL1Request Get "$($SL1Defaults.APIROOT)/api/device?$($Filter)&limit=$($Limit)&offset=$($i)&hide_filterinfo=1&extended_fetch=1").content)
								    foreach ($DeviceURI in ($Devices | Get-Member -MemberType NoteProperty).name ) {
									    ConvertTo-Json ($Devices.$DeviceURI)
								    }
								}
							}
							
						}
					}
					{ $_ -eq [system.net.httpstatuscode]::Forbidden }  { Write-Warning "You are not authorized to get information on devices"}
					{ $_ -eq [System.Net.HttpStatusCode]::NotFound } { Write-Warning "Device with id $($ID) is not found in the SL1 system" }
				}

			}
		}
	}
}

function ConvertTo-Device {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		$SL1Device,

		[Parameter(Mandatory, Position=1)]
		[int64]$ID
	)

	Process {
		$SL1Device | Add-Member -TypeName 'device'
		$SL1Device | Add-Member -NotePropertyName 'URI' -NotePropertyValue "/api/device/$($ID)"
		$SL1Device | Add-Member -NotePropertyName 'ID' -NotePropertyValue $ID
		$SL1Device | Add-Member -NotePropertyName 'Company' -NotePropertyValue "$( (ConvertFrom-Json ((Invoke-SL1Request GET "$($SL1Defaults.APIROOT)$($SL1Device.organization)" ).content)).company)"
		$SL1Device
	}
}