Import-Module "$($psscriptroot)\..\ScienceLogic-SL1\ScienceLogic-SL1.psm1" -Force
$SL1Cred = Import-Clixml -Path "$($MyInvocation.MyCommand.Path)\..\..\..\PrivateData\admin.xml"
$SL1URI = (Get-Content "$($MyInvocation.MyCommand.Path)\..\..\..\PrivateData\URI.json" | ConvertFrom-Json).URI

$Resources = ConvertFrom-Json "{ 'v1': {'SuccessMock' : 'Connected', 'SuccessCode' : '200' , 'URI': '$($SL1URI)' } }"

Describe "Get-SL1Organization" {
	Context "Validate ParameterSet ID" {
		It "returns a single device" {
			Connect-SL1 -URI $SL1URI -Credential $SL1Cred
			( Get-SL1Organization -Id 0 | Measure-Object ).Count -eq 1 | Should be $true
		}
	}

	Context "Validate ParameterSert Filter" {
		It "returns a single device by query" {
			Connect-SL1 -URI $SL1URI -Credential $SL1Cred
			( Get-SL1Organization -filter 'filter.0._id.eq=0' | Measure-Object ).Count -eq 1 | Should be $true

		}
	}
}