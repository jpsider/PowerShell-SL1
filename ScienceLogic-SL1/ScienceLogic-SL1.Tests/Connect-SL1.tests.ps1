Import-Module "$($psscriptroot)\..\ScienceLogic-SL1\ScienceLogic-SL1.psm1" -Force
$SL1Cred = Import-Clixml -Path "$($MyInvocation.MyCommand.Path)\..\..\..\PrivateData\admin.xml"
$SL1URI = (Get-Content "$($MyInvocation.MyCommand.Path)\..\..\..\PrivateData\URI.json" | ConvertFrom-Json).URI

$Resources = ConvertFrom-Json "{ 'v1': {'SuccessMock' : 'Connected', 'SuccessCode' : '200' , 'URI': '$($SL1URI)' } }"

Describe 'Connect-SL1' {
	Context 'Logging in' {
		It 'Ensures that Resources are loaded' {
			$Resources | Should Not BeNullOrEmpty
		}

		It 'Validates Credentials' {
			Mock Invoke-WebRequest -Verifiable -MockWith {
				return @{
					Content='Connected'
					StatusCode=[system.net.httpstatuscode]::OK
				}
			} -ParameterFilter {
				$uri -match $Resources.v1.URI
			} -ModuleName ScienceLogic-SL1
			$SL1Connection = Connect-SL1 -URI $SL1URI -Credential $SL1Cred -Passthru
			$SL1Connection.IsConnected | Should Be $true

			Assert-VerifiableMock

		}

		It 'Validates a successful connection' {
			$Return = Connect-SL1 -uri $SL1URI -Credential $SL1Cred -Passthru
			$Return.IsConnected | Should be $true
		}
	}
}
