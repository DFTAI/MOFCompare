
@{
  pester = 'latest'
  BR = @{
    DependsOn = 'BuildFolder'
    Version = 'master'
    Name = 'https://github.com/rdbartram/PSBuildRelease'
  }
  PSDependOptions = @{
    AddToPath = $True
    Target = '$DependencyFolder\Dependencies'
  }
  Configuration = 'latest'
  invokebuild = 'latest'
  BuildHelpers = 'latest'
  BuildFolder = @{
    DependencyType = 'Command'
    Source = 'Remove-Item .\.build -Force -Recurse -confirm:$false -ErrorAction SilentlyContinue; New-Item -Type Directory -Path .build -Force | Out-Null; New-Item -Type Directory -Path Dependencies -Force | Out-Null'
  }
  ExtractFolder = @{
    DependsOn = 'BR'
    Source = 'gci Dependencies\PSBuildRelease\BuildTasks | % {move-item $_.fullname .\.build -force}; sleep 1; remove-item .\Dependencies\PSBuildRelease -Force -Recurse'
    DependencyType = 'Command'
  }
}
