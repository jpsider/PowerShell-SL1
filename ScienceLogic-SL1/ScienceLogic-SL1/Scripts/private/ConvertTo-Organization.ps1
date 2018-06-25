function ConvertTo-Organization {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory, Position=0, ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		$SL1Organization,

		[Parameter(Mandatory, Position=1)]
		[int64]$Id
	)

	Process {
		$SL1Organization | Add-Member -TypeName 'organization'
		$SL1Organization | Add-Member -NotePropertyName 'URI' -NotePropertyValue "/api/organization/$($Id)"
		$SL1Organization | Add-Member -NotePropertyName 'ID' -NotePropertyValue $Id
		$SL1Organization
	}
}