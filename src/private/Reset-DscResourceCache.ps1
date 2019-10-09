using namespace Microsoft.PowerShell.DesiredStateConfiguration.Internal

function Reset-DscResourceCache {
    [cmdletbinding()]
    param()

    process {
        [DscClassCache]::ClearCache()
        [DscClassCache]::LoadDefaultCimKeywords()
    }
}
