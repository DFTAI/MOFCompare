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
                $propertiestocheck = $ReferenceMOF[$key].CimInstanceProperties.name.Where{ $key -notin @("sourceinfo") }
                if (Compare-Object $ReferenceMOF[$key] $DifferencingMOF[$key] -Property $propertiestocheck) {
                    $changedproperties = @()
                    foreach ($property in $propertiestocheck) {
                        $result = Compare-Object $ReferenceMOF[$key] $DifferencingMOF[$key] -Property $property
                        if ($result) {
                            $changedproperties += [PSCustomObject]@{
                                Name     = $property
                                NewValue = $result.where( { $_.SideIndicator -eq "=>" }).$property
                                OldValue = $result.where( { $_.SideIndicator -eq "<=" }).$property
                            }
                        }
                    }
                    $ChangedResources.Add($ReferenceMOF[$key].ResourceId, $changedproperties)
                }
            }

            $ReturnObject.Changed = $ChangedResources
        }

        Write-Output $ReturnObject
    }
}
