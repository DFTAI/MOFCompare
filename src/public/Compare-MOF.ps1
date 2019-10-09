using namespace System.Collections.Generic
function Compare-MOF {
    [cmdletbinding()]
    param(
        [parameter(Mandatory)]
        $ReferenceMOF,

        [parameter(Mandatory, ValueFromPipeline = $true)]
        $DifferencingMOF,

        [parameter()]
        [switch]
        $CompareProperties
    )

    process {
        $CompareResult = Compare-Object $ReferenceMOF.keys.ForEach{ $_ } $DifferencingMOF.keys.ForEach{ $_ } -IncludeEqual -PassThru

        $ReturnObject = [pscustomobject]@{
            Missing = $CompareResult.Where( { $_.SideIndicator -eq "<=" })
            New     = $CompareResult.Where( { $_.SideIndicator -eq "=>" })
            Changed = $null
        }

        if ($CompareProperties.IsPresent) {

            [Dictionary[string, PSCustomObject[]]]$ChangedResources = (New-Object 'System.Collections.Generic.Dictionary[string, PSCustomObject[]]')

            Foreach ($key in $CompareResult.Where( { $_.SideIndicator -eq "==" })) {
                $propertiestocheck = $ConfigurationElements[$key].CimInstanceProperties.name.Where{ $key -notin @("sourceinfo") }
                if (Compare-Object $ConfigurationElements[$key] $ConfigurationElements1[$key] -Property $propertiestocheck) {
                    $changedproperties = @()
                    foreach ($property in $propertiestocheck) {
                        $result = Compare-Object $ConfigurationElements[$key] $ConfigurationElements1[$key] -Property $property
                        if ($result) {
                            $changedproperties += [PSCustomObject]@{
                                Name     = $property
                                NewValue = $result.where( { $_.SideIndicator -eq "=>" }).$property
                                OldValue = $result.where( { $_.SideIndicator -eq "<=" }).$property
                            }
                        }
                    }
                    $ChangedResources.Add($ConfigurationElements[$key].ResourceId, $changedproperties)
                }
            }

            $ReturnObject.Changed = $ChangedResources
        }

        Write-Output $ReturnObject
    }
}
