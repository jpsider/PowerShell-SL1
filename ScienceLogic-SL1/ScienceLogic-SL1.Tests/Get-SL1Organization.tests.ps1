Import-Module "$($psscriptroot)\..\ScienceLogic-SL1\ScienceLogic-SL1.psm1" -Force
$SL1Cred = Import-Clixml -Path "$($MyInvocation.MyCommand.Path)\..\..\..\PrivateData\admin.xml"
$SL1URI = (Get-Content "$($MyInvocation.MyCommand.Path)\..\..\..\PrivateData\URI.json" | ConvertFrom-Json).URI

$Resources = ConvertFrom-Json "{ 'v1': {'SuccessMock' : 'Connected', 'SuccessCode' : '200' , 'URI': '$($SL1URI)' } }"

Describe "Get-SL1Organization" {
		Mock Invoke-WebRequest { new-object psobject -Property @{StatusCode=([System.Net.HttpStatusCode]::OK);Content="{
	""company"":  ""Bogus Name"",
	""address"":  ""Bogus Location"",
	""city"":  ""Reston"",
	""state"":  ""VA"",
	""zip"":  """",
	""country"":  ""US"",
	""contact_fname"":  ""ScienceLogic"",
	""contact_lname"":  ""Support"",
	""title"":  """",
	""dept"":  ""Customer Service"",
	""billing_id"":  """",
	""crm_id"":  """",
	""phone"":  ""(703)-354-1010"",
	""fax"":  ""(703)-336-8000"",
	""tollfree"":  ""(800)-SCI-LOGI"",
	""email"":  ""support@sciencelogic.com"",
	""date_create"":  null,
	""date_edit"":  ""1531744749"",
	""updated_by"":  ""/api/account/38"",
	""theme"":  ""1"",
	""longitude"":  """",
	""latitude"":  """",
	""notification_append"":  null,
	""custom_fields"":  {

						},
	""notes"":  {
					""URI"":  ""/api/organization/0/note/?hide_filterinfo=1\u0026limit=1000"",
					""description"":  ""Notes""
				},
	""logs"":  {
					""URI"":  ""/api/organization/0/log/?hide_filterinfo=1\u0026limit=1000"",
					""description"":  ""Logs""
				}
	}"}} -ParameterFilter { $URI -match '/api/organization/\d+'}
		Mock Invoke-WebRequest { New-Object psobject -Property @{StatusCode=([System.Net.HttpStatusCode]::OK);Content="{
		""company"":  ""System"",
		""address"":  ""Bogus Location"",
		""city"":  ""Reston"",
		""state"":  ""VA"",
		""zip"":  """",
		""country"":  ""US"",
		""contact_fname"":  ""ScienceLogic"",
		""contact_lname"":  ""Support"",
		""title"":  """",
		""dept"":  ""Customer Service"",
		""billing_id"":  """",
		""crm_id"":  """",
		""phone"":  ""(703)-354-1010"",
		""fax"":  ""(703)-336-8000"",
		""tollfree"":  ""(800)-SCI-LOGI"",
		""email"":  ""support@sciencelogic.com"",
		""date_create"":  null,
		""date_edit"":  ""1531744749"",
		""updated_by"":  ""/api/account/38"",
		""theme"":  ""1"",
		""longitude"":  """",
		""latitude"":  """",
		""notification_append"":  null,
		""custom_fields"":  {

						  },
		""notes"":  {
					  ""URI"":  ""/api/organization/0/note/?hide_filterinfo=1\u0026limit=1000"",
					  ""description"":  ""Notes""
				  },
		""logs"":  {
					 ""URI"":  ""/api/organization/0/log/?hide_filterinfo=1\u0026limit=1000"",
					 ""description"":  ""Logs""
				 }
	}"}} -ParameterFilter { $URI -match '/api/account/_self'}
		Mock Invoke-WebRequest { New-Object psobject -Property @{StatusCode=([System.Net.HttpStatusCode]::OK);Content="{
		""searchspec"":  {
						   ""fields"":  [
										  ""_id"",
										  ""address"",
										  ""billing_id"",
										  ""city"",
										  ""company"",
										  ""contact_fname"",
										  ""contact_lname"",
										  ""country"",
										  ""crm_id"",
										  ""date_create"",
										  ""date_edit"",
										  ""dept"",
										  ""email"",
										  ""fax"",
										  ""latitude"",
										  ""longitude"",
										  ""notification_append"",
										  ""phone"",
										  ""state"",
										  ""theme"",
										  ""title"",
										  ""tollfree"",
										  ""updated_by"",
										  ""updated_by/user"",
										  ""zip""
									  ],
						   ""options"":  {
										   ""hide_filterinfo"":  {
																   ""type"":  ""boolean"",
																   ""description"":  ""Suppress filterspec and current filter info if 1 (true)"",
																   ""default"":  ""0""
															   },
										   ""limit"":  {
														 ""type"":  ""int"",
														 ""description"":  ""Number of records to retrieve"",
														 ""default"":  ""100""
													 },
										   ""offset"":  {
														  ""type"":  ""int"",
														  ""description"":  ""Specifies the index of the first returned resource within the entire result set"",
														  ""default"":  ""0""
													  },
										   ""extended_fetch"":  {
																  ""type"":  ""boolean"",
																  ""description"":  ""Fetch entire resource if 1 (true), or resource link only if 0 (false)"",
																  ""default"":  ""0""
															  },
										   ""link_disp_field"":  {
																   ""type"":  ""enum"",
																   ""description"":  ""When not using extended_fetch, this determines which field is used for the \""description\"" of the resource link"",
																   ""default"":  ""main.company"",
																   ""values"":  [
																				  ""updated_by/user"",
																				  ""company"",
																				  ""address"",
																				  ""city"",
																				  ""state"",
																				  ""zip"",
																				  ""country"",
																				  ""contact_fname"",
																				  ""contact_lname"",
																				  ""title"",
																				  ""dept"",
																				  ""billing_id"",
																				  ""crm_id"",
																				  ""phone"",
																				  ""fax"",
																				  ""tollfree"",
																				  ""email"",
																				  ""date_create"",
																				  ""date_edit"",
																				  ""updated_by"",
																				  ""theme"",
																				  ""longitude"",
																				  ""latitude"",
																				  ""notification_append""
																			  ]
															   }
									   }
					   },
		""total_matched"":  63,
		""total_returned"":  1,
		""result_set"":  [
						   {
							   ""URI"":  ""/api/organization/0"",
							   ""description"":  ""System""
						   }
					   ]
	}"}} -ParameterFilter { $URI -match '/api/organization\?.+limit='}
		Mock Invoke-WebRequest { New-Object psobject @{StatusCode='OK' ; Content="{
		""searchspec"":  {
						   ""fields"":  [
										  ""_id"",
										  ""address"",
										  ""billing_id"",
										  ""city"",
										  ""company"",
										  ""contact_fname"",
										  ""contact_lname"",
										  ""country"",
										  ""crm_id"",
										  ""date_create"",
										  ""date_edit"",
										  ""dept"",
										  ""email"",
										  ""fax"",
										  ""latitude"",
										  ""longitude"",
										  ""notification_append"",
										  ""phone"",
										  ""state"",
										  ""theme"",
										  ""title"",
										  ""tollfree"",
										  ""updated_by"",
										  ""updated_by/user"",
										  ""zip""
									  ],
						   ""options"":  {
										   ""hide_filterinfo"":  {
																   ""type"":  ""boolean"",
																   ""description"":  ""Suppress filterspec and current filter info if 1 (true)"",
																   ""default"":  ""0""
															   },
										   ""limit"":  {
														 ""type"":  ""int"",
														 ""description"":  ""Number of records to retrieve"",
														 ""default"":  ""100""
													 },
										   ""offset"":  {
														  ""type"":  ""int"",
														  ""description"":  ""Specifies the index of the first returned resource within the entire result set"",
														  ""default"":  ""0""
													  },
										   ""extended_fetch"":  {
																  ""type"":  ""boolean"",
																  ""description"":  ""Fetch entire resource if 1 (true), or resource link only if 0 (false)"",
																  ""default"":  ""0""
															  },
										   ""link_disp_field"":  {
																   ""type"":  ""enum"",
																   ""description"":  ""When not using extended_fetch, this determines which field is used for the \""description\"" of the resource link"",
																   ""default"":  ""main.company"",
																   ""values"":  [
																				  ""updated_by/user"",
																				  ""company"",
																				  ""address"",
																				  ""city"",
																				  ""state"",
																				  ""zip"",
																				  ""country"",
																				  ""contact_fname"",
																				  ""contact_lname"",
																				  ""title"",
																				  ""dept"",
																				  ""billing_id"",
																				  ""crm_id"",
																				  ""phone"",
																				  ""fax"",
																				  ""tollfree"",
																				  ""email"",
																				  ""date_create"",
																				  ""date_edit"",
																				  ""updated_by"",
																				  ""theme"",
																				  ""longitude"",
																				  ""latitude"",
																				  ""notification_append""
																			  ]
															   }
									   }
					   },
		""total_matched"":  63,
		""total_returned"":  2,
		""result_set"":  {
						   ""/api/organization/0"":  {
														""company"":  ""Bogus Name"",
														""address"":  ""Bogus Location"",
														""city"":  """",
														""state"":  """",
														""zip"":  """",
														""country"":  ""BE"",
														""contact_fname"":  """",
														""contact_lname"":  """",
														""title"":  """",
														""dept"":  """",
														""billing_id"":  """",
														""crm_id"":  """",
														""phone"":  """",
														""fax"":  """",
														""tollfree"":  """",
														""email"":  """",
														""date_create"":  ""1513864233"",
														""date_edit"":  ""1528894685"",
														""updated_by"":  ""/api/account/38"",
														""theme"":  ""0"",
														""longitude"":  """",
														""latitude"":  """",
														""notification_append"":  """",
														""custom_fields"":  {

																		  },
														""notes"":  {
																	  ""URI"":  ""/api/organization/0/note/?hide_filterinfo=1\u0026limit=1000"",
																	  ""description"":  ""Notes""
																  },
														""logs"":  {
																	 ""URI"":  ""/api/organization/0/log/?hide_filterinfo=1\u0026limit=1000"",
																	 ""description"":  ""Logs""
																 }
													},
						   ""/api/organization/58"":  {
														""company"":  ""Another Bogus Name"",
														""address"":  ""Another Bogus Location"",
														""city"":  """",
														""state"":  """",
														""zip"":  """",
														""country"":  ""BE"",
														""contact_fname"":  """",
														""contact_lname"":  """",
														""title"":  """",
														""dept"":  """",
														""billing_id"":  """",
														""crm_id"":  """",
														""phone"":  """",
														""fax"":  """",
														""tollfree"":  """",
														""email"":  """",
														""date_create"":  ""1528267618"",
														""date_edit"":  ""1530704671"",
														""updated_by"":  ""/api/account/38"",
														""theme"":  ""0"",
														""longitude"":  """",
														""latitude"":  """",
														""notification_append"":  """",
														""custom_fields"":  {

																		  },
														""notes"":  {
																	  ""URI"":  ""/api/organization/58/note/?hide_filterinfo=1\u0026limit=1000"",
																	  ""description"":  ""Notes""
																  },
														""logs"":  {
																	 ""URI"":  ""/api/organization/58/log/?hide_filterinfo=1\u0026limit=1000"",
																	 ""description"":  ""Logs""
																 }
													}
					   }
	}"}} -ParameterFilter { $URI -match '/api/organization\?.*?limit=.*&extended_fetch=1$'}

		Context "Validate ParameterSet ID" {
			It "returns a single organization" {
				Connect-SL1 -URI $SL1URI -Credential $SL1Cred
				( Get-SL1Organization -Id 1 ).Company | should be "Bogus Name"
			}
		}

		Context "Validate ParameterSet Filter" {
			It "returns a single organization by query" {
				Connect-SL1 -URI $SL1URI -Credential $SL1Cred
				(Get-SL1Organization -filter 'filter.0._id.eq=0').Company | should be "Bogus Name"

			}

			It "verifies it works without parameters" {
				Connect-SL1 -URI $SL1URI -Credential $SL1Cred
				(get-SL1Organization).count | should -BeGreaterOrEqual 1
			}
		}
}