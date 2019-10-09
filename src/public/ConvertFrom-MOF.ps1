using namespace System.Collections.Generic
using namespace Microsoft.PowerShell.DesiredStateConfiguration.Internal

function ConvertFrom-MOF {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Path to one or more MOFs.")]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path
    )

    process {
        [Dictionary[Tuple`3[string, string, string], ciminstance]]$ConfigurationElements = (New-Object 'System.Collections.Generic.Dictionary[Tuple`3[string,string,string], ciminstance]')

        [DscClassCache]::ImportInstances((Resolve-Path $Path)) | Foreach-Object -Process {
            trap { $item }
            $item = $_
            if ($_.cimclass.cimclassname -eq "OMI_ConfigurationDocument") {
                $OMIConfig = $_
            } else {
                $KeyValues = $_.CimInstanceProperties.Where{ $_.flags -match 'key' }.Value -join ';'
                $ConfigurationElements.Add(
                    ([Tuple]::Create($_.modulename, $_.cimclass.cimclassname, $KeyValues)),
                    $_
                )
            }
        }

        Write-Output $ConfigurationElements
    }
}
