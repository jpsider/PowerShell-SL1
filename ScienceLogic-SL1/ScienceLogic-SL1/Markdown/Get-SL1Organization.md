---
external help file: ScienceLogic-SL1-help.xml
Module Name: sciencelogic-sl1
online version:
schema: 2.0.0
---

# Get-SL1Organization

## SYNOPSIS
Gets organizations in ScienceLogic

## SYNTAX

### ID (Default)
```
Get-SL1Organization [-Id] <Int64> [<CommonParameters>]
```

### Filter
```
Get-SL1Organization [-Filter] <String> [[-Limit] <Int64>] [<CommonParameters>]
```

## DESCRIPTION
The Get-SL1Organization cmdlet gets organizations in the ScienceLogic platform, referenced by the organization ID or by a filter.

## EXAMPLES

### EXAMPLE 1
```
Connect-SL1 -URI 'https://support.sciencelogic.com' -Credential ( Get-Credential )
```

PS C:\\\>Get-SL1Organization -ID 1

The first command connects to the ScienceLogic platform.
The second command gets the organization with ID 1

### EXAMPLE 2
```
Connect-SL1 -URI 'https://support.sciencelogic.com' -Credential ( Get-Credential )
```

PS C:\\\>Get-SL1Organization -Filter 'filter.0.billing_id.eq=B-1967354

The first command connects to the ScienceLogic platform.
The second command gets the organization with a billing id like B-1967354

## PARAMETERS

### -Id
An integer defining the ID of the ScienceLogic Organization

```yaml
Type: Int64
Parameter Sets: ID
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Filter
A Sciencelogic filter used to get a set of organizations

```yaml
Type: String
Parameter Sets: Filter
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Limit
The amount of organizations that need to be get in each batch.

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
