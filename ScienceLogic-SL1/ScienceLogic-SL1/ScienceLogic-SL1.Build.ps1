task . InstallDependencies, Clean , Analyze, Test, Archive , Publish, UpdateVersion

task InstallDependencies {
    Install-Module Pester -Force
    Install-Module PSScriptAnalyzer -Force
}

task Analyze {
    $scriptAnalyzerParams = @{
        Path = "$BuildRoot\"
        Severity = @('Error', 'Warning')
        Recurse = $true
        Verbose = $false
        ExcludeRule = 'PSUseDeclaredVarsMoreThanAssignments'
    }

    $saResults = Invoke-ScriptAnalyzer @scriptAnalyzerParams | ? { $_.ScriptName -notmatch 'Build\.ps1'}

    if ($saResults) {
        $saResults | Format-Table
        throw "One or more PSScriptAnalyzer errors/warnings where found."
    }
}

task Test {
    $invokePesterParams = @{
		Script = "..\$((($BuildFile -split '\\')[-1] -split '\.')[0]).Tests"
        Strict = $true
        PassThru = $true
        Verbose = $false
        EnableExit = $false
    }

    # Publish Test Results as NUnitXml
    $testResults = Invoke-Pester @invokePesterParams;

    $numberFails = $testResults.FailedCount
    assert($numberFails -eq 0) ('Failed "{0}" unit tests.' -f $numberFails)
}

task UpdateVersion {
    try 
    {
        $moduleManifestFile = "$(((("$($BuildFile)" -split '\\')[-1] -split '\.')[0]+'.psd1'))"
        $manifestContent = Get-Content $moduleManifestFile -Raw
        [version]$version = [regex]::matches($manifestContent,"ModuleVersion\s=\s\'(?<version>(\d+\.)?(\d+\.)?(\*|\d+))") | ForEach-Object {$_.groups['version'].value}
        $newVersion = "{0}.{1}.{2}" -f $version.Major, $version.Minor, ($version.Build + 1)

        $replacements = @{
            "ModuleVersion = '.*'" = "ModuleVersion = '$newVersion'"            
        }

        $replacements.GetEnumerator() | ForEach-Object {
            $manifestContent = $manifestContent -replace $_.Key,$_.Value
        }
        $manifestContent | Set-Content -Path "$BuildRoot\$moduleManifestFile"
    }
    catch
    {
        Write-Error -Message $_.Exception.Message
        $host.SetShouldExit($LastExitCode)
    }
}

task Clean {
    $Artifacts = "$BuildRoot\Artifacts\$((("$($BuildFile)" -split '\\')[-1] -split '\.')[0])"
    
    if (Test-Path -Path $Artifacts)
    {
        Remove-Item "$Artifacts/*" -Recurse -Force
    }

    New-Item -ItemType Directory -Path $Artifacts -Force |Out-Null
}

task Archive {
    $Artifacts = "$BuildRoot\Artifacts\$((("$($BuildFile)" -split '\\')[-1] -split '\.')[0])"
    $ModuleName = ($buildroot -split '\\')[-1]
    Copy-Item -Path .\ScienceLogic-SL1.psd1 -Destination "$Artifacts"
    Copy-Item -Path .\ScienceLogic-SL1.psm1 -Destination "$Artifacts"
    Copy-Item -Path .\Scripts -Destination "$Artifacts"
	Copy-Item -Path .\Format -Destination "$Artifacts" -Recurse
	Copy-Item -Path .\Type -Destination "$Artifacts" -Recurse
}

task Publish {
	Publish-Module -Path "$BuildRoot\Artifacts\$((("$($BuildFile)" -split '\\')[-1] -split '\.')[0])" -NuGetApiKey 2bf0c731-045b-4eb6-9bfa-7357370fd28b
}