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

Describe 'Get-SL1Device' {
	Context 'Validate ParameterSetName ID' {
		It 'Verifies a single device is returned' {
			Connect-SL1 -URI $SL1URI -Credential $SL1Cred
			( Get-SL1Device -Id 1944 | Measure-Object ).Count | Should be 1
		}

		It 'Verifies no device is returned' {
			Connect-SL1 -URI $SL1URI -Credential $SL1Cred
			( Get-SL1Device -Id 995997 | Measure-Object ).Count | Should be 0
		}

		It 'verifies the Company' {
			Connect-SL1 -URI $SL1URI -Credential $SL1Cred
			( get-sl1Device -id 1954 ).Company | Should Not Be ""
		}
	}

	Context 'Validate ParameterSetName Filter' {
		It "verifies a correct organization id filter" {
			Connect-SL1 -URI $SL1URI -Credential $SL1Cred
			(Get-SL1Device -Filter 'filter.0.organization.eq=15').Count | Should be 6  #in our case of course
		}
	}
}
	