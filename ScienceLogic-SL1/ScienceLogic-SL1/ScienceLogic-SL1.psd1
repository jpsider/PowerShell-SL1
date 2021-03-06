@{

# Script module or binary module file associated with this manifest.
RootModule = 'ScienceLogic-SL1.psm1'

# Version number of this module.
ModuleVersion = '1.2.3'

# ID used to uniquely identify this module
GUID = 'f060cfd6-9865-4d61-99f7-daaa8e95a3b0'

# Author of this module
Author = 'Tom Robijns'

# Company or vendor of this module
CompanyName = 'Realdolmen'

# Copyright statement for this module
Copyright = ''

# Description of the functionality provided by this module
Description = 'PowerShell wrapper for ScienceLogic SL1 REST API.
SL1 is the new name of ScienceLogic''s EM7. the API has been rewritten and enhanced.'

# Minimum version of the Windows PowerShell engine required by this module
# PowerShellVersion = ''

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module
DotNetFrameworkVersion = '4.5'

# Minimum version of the common language runtime (CLR) required by this module
CLRVersion = '4.0'

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
TypesToProcess = 'xml\ScienceLogic-SL1.Types.ps1xml'

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = 'xml\ScienceLogic-SL1.Format.ps1xml'

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module
FunctionsToExport = @('Connect-SL1', 'Get-SL1Device', 'Get-SL1Organization', 'Invoke-SL1Request', 'ConvertTo-Organization','Test-SL1Connected','ConvertTo-Organization')

# Cmdlets to export from this module
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = @()

# Aliases to export from this module
AliasesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess
PrivateData = @{
	PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        # Tags = @()

        # A URL to the license for this module.
		LicenseUri = 'https://github.com/trir262/PowerShell-SL1/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/trir262/PowerShell-SL1'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = '1.2.0 Added functinality to get Organization.'

        # Prerelease string of this module
        #Prerelease = 'alpha'

        # Flag to indicate whether the module requires explicit user acceptance for install/update
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

	} # End of PSData hashtable

}# End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}



































