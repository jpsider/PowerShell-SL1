---
external help file: ScienceLogic-SL1-help.xml
Module Name: sciencelogic-sl1
online version:
schema: 2.0.0
---

# Get-SL1Device

## SYNOPSIS
Gets a device in ScienceLogic by ID

## SYNTAX

### Filter (Default)
```
Get-SL1Device [[-Filter] <String>] [[-Limit] <Int64>] [<CommonParameters>]
```

### ID
```
Get-SL1Device [[-Id] <Int64>] [<CommonParameters>]
```

## DESCRIPTION
The Get-SL1Device cmdlet gets a device in the ScienceLogic platform, referenced by the device ID.

## EXAMPLES

### EXAMPLE 1
```
PS C:\>Connect-SL1 -URI 'https://support.sciencelogic.com' -Credential ( Get-Credential )
PS C:\>Get-SL1Device -ID 1
```

```
The first command connects to the ScienceLogic platform.
The second command gets device with ID 1
```

### EXAMPLE 2
```
PS C:\>Connect-SL1 -URI 'https://support.sciencelogic.com' -Credential ( Get-Credential )
PS C:\>Get-SL1Device -Filter 'filter.0.organization.eq=15'
```

```
The first command connects to the ScienceLogic platform.
The second command gets all devices for organization with id 15, with a limit of 100 (default).
```

### Example 3
```
PS C:\>Connect-SL1 -URI 'https://support.sciencelogic.com' -Credential (Get-Credential )
PS C:\>Get-SL1Device
```

```
The first command connect to the ScienceLogic platform.
The second command get the first 100 devices.
```

## PARAMETERS

### -Id
An integer defining the ID of the ScienceLogic Device

```yaml
Type: Int64
Parameter Sets: ID
Aliases:

Required: False
Position: 1
Default value: 0
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Filter
A Sciencelogic filter used to get a set of devices

```yaml
Type: String
Parameter Sets: Filter
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Limit
The amount of devices that need to be get in each batch.

```yaml
Type: Int64
Parameter Sets: Filter
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
