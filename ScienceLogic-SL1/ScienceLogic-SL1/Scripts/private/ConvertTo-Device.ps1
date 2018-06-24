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