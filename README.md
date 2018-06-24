# PowerShell-SL1
PowerShell wrapper for ScienceLogic SL1 REST API.
SL1 is the new name of ScienceLogic's EM7. the API has been rewritten and enhanced.

## Usage

	Import-Module ScienceLogic-SL1	# Load the module
	Connect-SL1						# Login to the SL1 Environment, URI and Credentials are required
	Get-SL1Device -ID 1				# Get the device with id 1
	Get-SL1Device -Filter 'filter.0.organization.eq=1' # Get all devices for organization 1

## Connect-SL1
Validates and stores the URI and credential required for accessing the SL1 API in-memory.

### Syntax
	Connect-SL1 [-URI] <URI> [-Credential <Credential>] [-Formatted] [-IgnoreSSLErrors] [<CommonParameters>]

Parameter | Required | Pos  | Description 
--------- | :------: | ---: | ----------- 
*URI* | X | 1 | The API root URI, with /api at the end
*Credential* |  | 2 | The credential required to log in 
*Formatted* |  |  | Specify this when you&#39;ll be using a HTTP debugger like Fiddler. It will cause the JSON to be formatted with whitespace for easier reading, but is more likely to result in errors with larger responses. 
*IgnoreSSLErrors* |  |  | If specified, SSL errors will be ignored in all SSL requests made from this PowerShell session. This is an awful hacky way of doing this and it should only be used for testing. 

### Example
	Connect-SL1 -URI 'https://support.sciencelogic.com' -Credential (Get-Credential)

This command creates a connection to SL1 support.sciencelogic.com, using entered credentials.
*** 

## Get-SL1Device
Gets one or more devices from the ScienceLogic platform.

### Syntax
	Get-SL1Device [-ID] <Int64> [<CommonParameters>]
	Get-SL1Device [-Filter] <String> [[-Limit] <Int64>] [<CommonParameters>]

Parameter | Required | Pos  | ParameterSetName | Description 
--------- | :------: | ---: | ---------------- | -----------
*ID* | X | 1 | ID | The ID of the device in ScienceLogic
*Filter* | X | 1 | Filter | A Sciencelogic API filter
*Limit* |  | 2 | Filter | The amount of devices that should be retrieved in bulk. If this parameter is omitted, the default of 100 is used.

### Example 1
	Connect-SL1 -URI 'https://support.sciencelogic.com' -Credential (Get-Credential)
	Get-SL1Device -ID 1

	The first command connects to the ScienceLogic platform.
	The second command retrieves device with ID 1

### Example 2
	Connect-SL1 -URI 'https://support.sciencelogic.com' -Credential (Get-Credential)
	Get-SL1Device -Filter 'filter.0.organization.eq=1' -Limit 50

	The first command connects to the ScienceLogic platform.
	The second command gets all devices for organization with id 1. The limit is set to 50 so the module will request the devices in batches of 50 devices.

***