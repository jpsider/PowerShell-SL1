Function Get-SL1Organization {
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
		if (!(Test-SL1Connected)) {
			Throw "Connect-SL1 needs to be called first"
		} else {
			Write-Output "Connected to Instance."
		}

		if ($PSCmdlet.ParameterSetName -eq 'Filter' -and $Limit -eq 0) {
			$Limit = $Script:SL1Defaults.DefaultLimit
		}
	}

	Process {
		switch ($PSCmdlet.ParameterSetName) {
			'ID' {
				$SL1Organization = Invoke-SL1Request GET "$($Script:SL1Defaults.APIROOT)/api/organization/$($Id)"
				switch ($SL1Organization.StatusCode) {
					{ $_ -eq [system.net.httpstatuscode]::OK } { 
						$Organization = ConvertFrom-Json $SL1Organization.content
						ConvertTo-Organization -SL1Organization $Organization -ID $Id
					}
					{ $_ -eq [system.net.httpstatuscode]::Forbidden } { Write-Warning "You are not authorized to get information of organization with id $($Id)"}
					{ $_ -eq [System.Net.HttpStatusCode]::NotFound } { Write-Warning "organization with id $($Id) is not found in the SL1 system" }
				}
			}
			'Filter' {
				if ($Filter -ne "") {
					$SL1OrganizationURI = "$($Script:SL1Defaults.APIROOT)/api/organization?$($Filter)&limit=$($Limit)"
				} else {
					$SL1OrganizationURI = "$($Script:SL1Defaults.APIROOT)/api/organization?limit=$($Limit)"
				}
				# ******
				# This line replaces the two Invoke-SL1Request calls that were previously used. This will help with testing!
				# ******
				$SL1OrganizationqueryData = Invoke-SL1Request -Method Get -Uri $SL1OrganizationURI

				switch ($SL1OrganizationqueryData.StatusCode) {
					{ $_ -eq [system.net.httpstatuscode]::OK} {
						$Json = ConvertFrom-Json $SL1OrganizationqueryData.content
						if ($Json.total_matched -eq 0) {
							Write-Warning "No organizations found with filter '$($Filter)'"
						} else {
							# ******
							# I don't know your solution well enough, is this next line required? or could it just use the $SL1OrganizationqueryData from above? or could that call be modified using the options below?
							# ******
							$Organizations = ConvertFrom-Json ((Invoke-SL1Request Get "$($Script:SL1Defaults.APIROOT)/api/organization?$($Filter)&limit=$($Limit)&hide_filterinfo=1&extended_fetch=1").Content)
							foreach ($Organization in (($Organizations | Get-Member -MemberType NoteProperty).name) ) {
								ConvertTo-Organization -SL1Organization $Organizations.$OrganizationURI -ID "$( ($OrganizationURI -split '/')[-1])"
							}
						}
					}
					{ $_ -eq [system.net.httpstatuscode]::Forbidden }  { Write-Warning "You are not authorized to get information on organizations"}
					{ $_ -eq [System.Net.HttpStatusCode]::NotFound } { Write-Warning "Organization with id $($Id) is not found in the SL1 system" }
				}

			}
		}
	}

}