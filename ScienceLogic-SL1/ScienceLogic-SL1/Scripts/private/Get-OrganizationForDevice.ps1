function Get-OrganizationForDevice {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory, Position=1, ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		[pscustomobject]$Devices
	)

	End {
		$Organizations = foreach ($DeviceURI in (($Devices | gm -MemberType NoteProperty ).Name)) {
			$devices.$DeviceURI.organization
		} 
		$OrgIDs = ($organizations |Group-Object).Name | % { ($_ -split '/')[-1] }
		$OrgFilters = for ($i=0; $i -lt ($OrgIDs.Count); $i++ ) {
			"filter.$($i)._id.eq=$($OrgIDs[$i])"
		}
		$Organizations = get-SL1Organization -Filter ($OrgFilters -join '&')
		$Organizations
	}
}

