Import-Module "$($psscriptroot)\..\ScienceLogic-SL1\ScienceLogic-SL1.psm1" -Force
$SL1Cred = Import-Clixml -Path "$($MyInvocation.MyCommand.Path)\..\..\..\PrivateData\admin.xml"
$SL1URI = (Get-Content "$($MyInvocation.MyCommand.Path)\..\..\..\PrivateData\URI.json" | ConvertFrom-Json).URI

$Resources = ConvertFrom-Json "{ 'v1': {'SuccessMock' : 'Connected', 'SuccessCode' : '200' , 'URI': '$($SL1URI)' } }"

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
	