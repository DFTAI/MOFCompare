using namespace Microsoft.PowerShell.DesiredStateConfiguration.Internal

function Import-DscResourceToCache {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Management.Automation.PSModuleInfo]
        $Module
    )

    begin {
        $errors = New-Object System.Collections.ObjectModel.Collection[Exception]
    }

    process {
        trap { }
        Write-Verbose "Processing module $($Module.Name) $($Module.Version)"

        # script/binary resources
        $importedSchemaFile = ""
        [DscClassCache]::ImportCimKeywordsFromModule($Module, $null, [ref]$importedSchemaFile) | Out-Null

        # class resources
        [DscClassCache]::ImportClassResourcesFromModule($Module, $Module.ExportedDscResources, $null) | Out-Null
    }
}
