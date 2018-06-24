Function Invoke-SL1Request {
	<#
	.Synopsis
		This function does a call to SL1
	
	.Description
		Invoke-SL1Request is an internal function that wraps PowerShell's invoke-WebRequest. 
		Using a correct URI and Method, this function will use the previously-defined Credential 
	
	.Parameter Method
		Any of the following values: Get, Post, Put and Delete
	
	.Parameter URI
		The URI is a URL used to retrieve content from SL1
	#>
	[Cmdletbinding()]
	Param (
		[Parameter(Mandatory=$true, Position=0)]
		[ValidateSet('Get','Post','Put','Delete')]
		[String]$Method,
		
		[Parameter(Mandatory=$true, Position=1)]
		[URI]$URI
	)

	Process {
		Remove-Variable IWRError -ErrorAction SilentlyContinue 
		try {
			$IWRResponse = Invoke-WebRequest -Method $Method -Uri $URI -MaximumRedirection 0 -Credential $SL1Defaults.Credential -ErrorAction SilentlyContinue -ErrorVariable IWRError
			switch ($IWRResponse.StatusCode) {
				{ $_ -eq [System.Net.HttpStatusCode]::OK} { $IWRResponse }
				{ $_ -eq [System.Net.HttpStatusCode]::Redirect} { Invoke-SL1Request $Method "$($SL1Defaults.APIRoot)$($IWRResponse.Headers['Location'])" -MaximumRedirection 0 -Credential $SILOCred -ErrorAction SilentlyContinue -ErrorVariable IWRError }
			}
		} Catch [System.Exception] {
			switch ($IWRError.InnerException.Response.StatusCode) {
				{ $_ -eq [System.Net.HttpStatusCode]::Unauthorized} { $_.Exception.Response }
				{ $_ -eq [System.Net.HttpStatusCode]::NotFound} { $_.Exception.Response }
				{ $_ -eq [system.net.httpstatuscode]::Forbidden} { $_.Exception.Response }
			}
		}
	}
}
