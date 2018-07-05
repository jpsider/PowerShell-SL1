---
external help file: ScienceLogic-SL1-help.xml
Module Name: sciencelogic-sl1
online version:
schema: 2.0.0
---

# Connect-SL1

## SYNOPSIS
Connect-SL1 prepares a connection to ScienceLogic's SL1 environment.

## SYNTAX

```
Connect-SL1 [-Uri] <String> [-Credential] <PSCredential> [-Passthru] [<CommonParameters>]
```

## DESCRIPTION
Use this function to prepare your powershell session to connect to ScienceLogic's SL1. 
This only needs to be called once every session.

## EXAMPLES

### EXAMPLE 1
```
$SL1Credential = Get-Credential
```

Connect-SL1 -URI 'https://support.sciencelogic.com' -Credential $SL1Credential

The first command registers a credential.
The second command creates a connection to ScienceLogic and saves it in memory for subsequent calls to the environment.

## PARAMETERS

### -Uri
Enter the base url of the SL1 environment

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Credential
A username and password required to connect to SL1.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Passthru
Returns a connection status result by performing a test call.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
