function Get-OrganizationForDevice {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory, Position=1, ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		[psobject]$Devices
	)

	End {
		$Organizations = foreach ($DeviceURI in (($Devices | Get-Member -MemberType NoteProperty ).Name)) {
			$devices.$DeviceURI.organization
		} 
		$OrgIDs = ($organizations |Group-Object).Name | ForEach-Object { ($_ -split '/')[-1] }

		$Organizations = if ($OrgIDs.count -eq 1) {
			Get-SL1Organization -Id $OrgIDs
		} else {
			$OrgFilters = for ($i=0; $i -lt ($OrgIDs.Count); $i++ ) {
				"filter.$($i)._id.eq=$($OrgIDs[$i])"
			}
			Get-SL1Organization -Filter ($OrgFilters -join '&')
		}
		$Organizations
	}
}

