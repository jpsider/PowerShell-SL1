# PowerShell-SL1
PowerShell wrapper for ScienceLogic SL1 REST API.
SL1 is the new name of ScienceLogic's EM7. the API has been rewritten and enhanced.

## Usage

	Import-Module ScienceLogic-SL1	# Load the module
	Connect-SL1						# Login to the SL1 Environment, URI and Credentials are required
	Get-SL1Device -Limit 10			# Get 10 random devices from the SL1 Environment

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

*** 
