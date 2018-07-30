$script:ModuleName = 'PowerShell-SL1'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-SL1Organization function for $moduleName" -Tags Build {
    function Test-SL1Connected {} # I don't want to run this command, so I create a fake function to ensure I return the value I expect.
    function Invoke-SL1Request {} # I'm not testing this function, just evaluating the return, and doing something based on that data.
    function ConvertTo-Organization {} # All functions should have their own specific unit tests.
    function Write-Output {} # This is just habit. Remember you are testing this script, not other functions. it's just a unit test.
    It "Should Throw." {
        Mock -CommandName 'Test-SL1Connected' -MockWith {
            throw "Connect-SL1 needs to be called first"
        }
        Mock -CommandName "Write-Output" -MockWith {}
        {Get-SL1Organization -ID -Filter -Limit} | Should -Throw
        Assert-MockCalled -CommandName 'Test-SL1Connected' -Times 1 -Exactly
        Assert-MockCalled -CommandName 'Write-Output' -Times 0 -Exactly
    }
    It "Should Not Throw and return data!" {
        Mock -CommandName 'Test-SL1Connected' -MockWith {
            return $true
        }
        Mock -CommandName "Write-Output" -MockWith {}
        Mock -CommandName 'Invoke-SL1Request' -MockWith {
            $RawReturn = @{
                StatusCode = "OK"
                Content = @{
                    Company            = 'Bogus Company'
                    Address     = 'Bogus Company'
                    City       = 'Reston'
                    State = 'VA'
                }               
            }
            $ReturnJson = $RawReturn | ConvertTo-Json
            $ReturnData = $ReturnJson | convertfrom-json
            return $ReturnData
        }
        {Get-SL1Organization -ID 1} | Should -Throw
        Assert-MockCalled -CommandName 'Test-SL1Connected' -Times 2 -Exactly
        Assert-MockCalled -CommandName 'Write-Output' -Times 1 -Exactly
    }
    # You'd setup each "It" to represent a different decision in your script.
}