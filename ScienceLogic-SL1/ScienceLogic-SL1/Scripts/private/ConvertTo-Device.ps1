function ConvertTo-Device {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		$SL1Device,

		[Parameter(Mandatory, Position=1)]
		[ValidateRange(0,([int64]::MaxValue))]
		[int64]$Id,

		[Parameter(Mandatory, Position=2)]
		[ValidateNotNullOrEmpty()]
		[String]$CompanyName
	)

	Process {
		$SL1Device | Add-Member -TypeName 'device'
		$SL1Device | Add-Member -NotePropertyName 'URI' -NotePropertyValue "/api/device/$($Id)"
		$SL1Device | Add-Member -NotePropertyName 'ID' -NotePropertyValue $Id
		$SL1Device | Add-Member -NotePropertyName 'Company' -NotePropertyValue $CompanyName
		$SL1Device
	}
}