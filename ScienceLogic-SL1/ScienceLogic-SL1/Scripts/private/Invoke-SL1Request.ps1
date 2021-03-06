Function Invoke-SL1Request {
	[Cmdletbinding()]
	Param (
		[Parameter(Mandatory=$true, Position=0)]
		[ValidateSet('Get','Post','Put','Delete')]
		[String]$Method,
		
		[Parameter(Mandatory=$true, Position=1)]
		[URI]$Uri
	)

	Process {
		Remove-Variable IWRError -ErrorAction SilentlyContinue 
		$MyProgressPreference = $ProgressPreference
		$ProgressPreference = 'SilentlyContinue'
		try {
			$IWRResponse = Invoke-WebRequest -Method $Method -Uri $Uri -MaximumRedirection 0 -Credential $Script:SL1Defaults.Credential -ErrorAction SilentlyContinue -ErrorVariable IWRError
			switch ($IWRResponse.StatusCode) {
				{ $_ -eq [System.Net.HttpStatusCode]::OK} { $IWRResponse }
				{ $_ -eq [System.Net.HttpStatusCode]::Redirect} { Invoke-SL1Request $Method "$($Script:SL1Defaults.APIRoot)$($IWRResponse.Headers['Location'])" -MaximumRedirection 0 -Credential $SILOCred -ErrorAction SilentlyContinue -ErrorVariable IWRError }
			}
		} Catch [System.Exception] {
			switch ($IWRError.InnerException.Response.StatusCode) {
				{ $_ -eq [System.Net.HttpStatusCode]::Unauthorized} { $_.Exception.Response }
				{ $_ -eq [System.Net.HttpStatusCode]::NotFound} { $_.Exception.Response }
				{ $_ -eq [system.net.httpstatuscode]::Forbidden} { $_.Exception.Response }
				default { $_ }
			}
		}
		$ProgressPreference = $MyProgressPreference
	}
}
