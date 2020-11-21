Describe "ConvertFrom-MOF" {
    BeforeAll {
        Import-Module $PSScriptRoot/../BuildOutput/MOFCompare/MOFCompare.psd1 -Force

        Configuration HelloWorld {

            # Import the module that contains the File resource.
            Import-DscResource -ModuleName PsDesiredStateConfiguration

            # The Node statement specifies which targets to compile MOF files for, when
            # this configuration is executed.
            Node $AllNodes.NodeName {

                # The File resource can ensure the state of files, or copy them from a
                # source to a destination with persistent updates.
                File HelloWorld {
                    DestinationPath = "C:\Temp\HelloWorld.txt"
                    Ensure          = "Present"
                    Contents        = $node.content
                }
            }
        }

        $ConfigData = @{
            AllNodes = @(
                @{
                    nodename = "localhost"
                    content  = "Some Text"
                },
                @{
                    nodename = "localhost1"
                    content  = "Some Other Text"
                }
            )
        }

        HelloWorld -ConfigurationData $ConfigData -OutputPath TestDrive:\
    }

    Context "default" {
        BeforeAll {
            Initialize-DscResourceCache
        }

        $TestCases = @(
            @{
                node = 'localhost'
                resources = @(
                    @{
                        ResourceId = "[File]HelloWorld"
                        DestinationPath = "C:\Temp\HelloWorld.txt"
                        Ensure          = "Present"
                        Contents        = "Some Text"
                    }
                )
            },
            @{
                node = 'localhost1'
                resources = @(
                    @{
                        ResourceId = "[File]HelloWorld"
                        DestinationPath = "C:\Temp\HelloWorld.txt"
                        Ensure          = "Present"
                        Contents        = "Some Other Text"
                    }
                )
            }
        )

        It "should have matching properties in $($node).mof" -TestCases $TestCases {
            param($node, $resources)
            $path = Get-Item testdrive:\$node.mof

            $Mof = ConvertFrom-MOF $path.fullname

            foreach ( $resource in $resources) {
                $Configuration = $Mof.values | ? ResourceId -eq $resource.ResourceId

                $resource.keys | % {
                    $Configuration.$_ | Should -Be $resource[$_]
                }
            }
        }
    }
}
