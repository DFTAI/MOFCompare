function Initialize-DscResourceCache {
    [cmdletbinding()]
    param(
        [parameter()]
        [string[]]
        $ModulePathsToImport
    )

    begin {
        Reset-DscResourceCache
        $OldPSModulePath = $env:PSModulePath
        if ($ModulePathsToImport.count -gt 0) {
            $env:PSModulePath = $ModulePathsToImport.ForEach{ Resolve-Path $_ -ea SilentlyContinue } -join ';'
        }
    }

    process {
        Get-Module -ListAvailable | Import-DscResourceToCache -ErrorAction Continue
    }

    end {
        $env:PSModulePath = $OldPSModulePath
    }
}
