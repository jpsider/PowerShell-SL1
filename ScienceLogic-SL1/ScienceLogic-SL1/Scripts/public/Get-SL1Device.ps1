Function Get-SL1Device {
	[CmdletBinding(DefaultParameterSetName='Filter')]
	Param(
		[Parameter(Position=0, ValueFromPipeline, ParameterSetName='ID')]
		[int64]$Id,

		[Parameter(Position=0, ValueFromPipeline, ParameterSetName='Filter')]
		[string]$Filter,

		[Parameter(Position=1, ParameterSetName='Filter')]
		[ValidateRange(0,([int64]::MaxValue))]
		[int64]$Limit
	)

	Begin {
		Test-SL1Connected
		if ($Limit -eq 0) {
			$Limit = $Script:SL1Defaults.DefaultLimit
		}
	}

	Process {
		switch ($PSCmdlet.ParameterSetName) {
			'ID' {
				if ($id) {
					$SL1Device = Invoke-SL1Request GET "$($Script:SL1Defaults.APIROOT)/api/device/$($Id)"
					switch ($SL1Device.StatusCode) {
						{ $_ -eq [system.net.httpstatuscode]::OK } { 
							$Device = ConvertFrom-Json $SL1Device.content
							ConvertTo-Device -SL1Device $Device -ID $Id
						}
						{ $_ -eq [system.net.httpstatuscode]::Forbidden } { Write-Warning "You are not authorized to get information on device with id $($Id)"}
						{ $_ -eq [System.Net.HttpStatusCode]::NotFound } { Write-Warning "Device with id $($Id) is not found in the SL1 system" }
					}
				} else {
					Get-SL1Device -Filter 'filter.0.name.contains=bru-in-sclo'
				}
			}
			'Filter' {
				if ($filter -ne "") {
					$SL1DeviceQuery = Invoke-SL1Request Get "$($Script:SL1Defaults.APIROOT)/api/device?$($Filter)&limit=$($Limit)"
				} else {
					$SL1DeviceQuery = Invoke-SL1Request Get "$($Script:SL1Defaults.APIRoot)/api/device?limit=$($Limit)"
				}
				switch ($SL1Devicequery.StatusCode) {
					{ $_ -eq [system.net.httpstatuscode]::OK} {
						$Json = ConvertFrom-Json $SL1DeviceQuery.content
						if ($Json.total_matched -eq 0) {
							Write-Warning "No devices found with filter '$($Filter)'"
						} else {
							$Devices = ConvertFrom-Json ((Invoke-SL1Request Get "$($Script:SL1Defaults.APIROOT)/api/device?$($Filter)&limit=$($Limit)&hide_filterinfo=1&extended_fetch=1").Content)
							$Organizations = $Devices | Get-OrganizationForDevice 
							foreach ($DeviceURI in (($Devices | Get-Member -MemberType NoteProperty).name) ) {
								$Org = $Organizations | ? { $_.URI -eq ($Devices.$DeviceURI.Organization)}
								ConvertTo-Device -SL1Device $Devices.$DeviceURI -ID "$( ($DeviceURI -split '/')[-1])" -CompanyName ( ($Organizations | Where-Object { $_.URI -eq ($Devices.$DeviceURI.organization) }).Company )
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