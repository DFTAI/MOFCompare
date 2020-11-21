Describe "Compare-MOF" {
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

                File GoodbyeWorld {
                    DestinationPath = "C:\Temp\$($node.Nodename).txt"
                    Ensure          = "Present"
                    Contents        = "Test"
                }

                File GoodbyeAswellWorld {
                    DestinationPath = "C:\Temp1\$($node.Nodename).txt"
                    Ensure          = "Present"
                    Contents        = "Test"
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

            $localhostpath = Get-Item testdrive:\localhost.mof
            $localhostpath1 = Get-Item testdrive:\localhost1.mof

            $LocalhostMof = ConvertFrom-MOF $localhostpath.fullname
            $Localhost1Mof = ConvertFrom-MOF $localhostpath1.fullname

            $Comparison = Compare-MOF $LocalhostMof $localhost1mof -CompareProperties
        }

        It "should have 1 remove resource" -TestCases $TestCases {
            $Comparison.Missing | Should -HaveCount 2
        }
        It "should have 1 changed resource" -TestCases $TestCases {
            $Comparison.Changed | Should -HaveCount 1

            $Comparison.Changed["[File]HelloWorld"].Name | Should -Be "Contents"
        }
        It "should have 1 add resource" -TestCases $TestCases {
            $Comparison.New | Should -HaveCount 2
        }
    }
}
