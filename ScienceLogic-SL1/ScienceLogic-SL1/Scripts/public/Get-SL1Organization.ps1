Function Get-SL1Organization {
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
				$SL1OrganizationQuery = Invoke-SL1Request Get "$($Script:SL1Defaults.APIROOT)/api/organization?$($Filter)&limit=$($Limit)"

				switch ($SL1Organizationquery.StatusCode) {
					{ $_ -eq [system.net.httpstatuscode]::OK} {
						$Json = ConvertFrom-Json $SL1OrganizationQuery.content
						if ($Json.total_matched -eq 0) {
							Write-Warning "No organizations found with filter '$($Filter)'"
						} else {
							if ($Json.total_matched -eq $Json.total_returned) {
								$Organizations = ConvertFrom-Json ((Invoke-SL1Request Get "$($Script:SL1Defaults.APIROOT)/api/organization?$($Filter)&limit=$($Limit)&hide_filterinfo=1&extended_fetch=1").Content)
								foreach ($OrganizationURI in (($Organizations | Get-Member -MemberType NoteProperty).name) ) {
									ConvertTo-Organization -SL1Organization $Organizations.$OrganizationURI -ID "$( ($OrganizationURI -split '/')[-1])"
								}
							} else {
								for ($i=0; $i -lt $Json.total_matched; $i += $Limit ) {
									$Organizations = ConvertFrom-Json ((Invoke-SL1Request Get "$($Script:SL1Defaults.APIROOT)/api/organization?$($Filter)&limit=$($Limit)&offset=$($i)&hide_filterinfo=1&extended_fetch=1").content)
								    foreach ($OrganizationURI in ($Organizations | Get-Member -MemberType NoteProperty).name ) {
									    ConvertTo-Organization -SL1Organization $Organizations.$OrganizationURI -ID "$( ($OrganizationURI -split '/')[-1])"
								    }
								}
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