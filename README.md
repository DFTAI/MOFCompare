# MOFCompare

MOFCompare 🔬 provides a few cmdlets to help parsing and comparing DSC MOF files. This can be useful for all sorts of reason, the one that often gets brought up is the similarity it has to terraform plan feature. Comparing any two MOF related or otherwise, will provide an output of the added, removed and changed resources. Perhaps you need to monitor change over time, perhaps you need to know what your compilation has actually done or maybe you need to check the configuration between two seperate machines.

If you have any questions or problems, just raise a bug of tweet me at the link below.

🐱‍💻 MOFCompare is built and tested in Azure DevOps and is distributed via the PowerShell gallery.

[![pester](https://img.shields.io/azure-devops/tests/rdbartram/GitHubPipelines/11.svg?label=pester&logo=azuredevops&style=for-the-badge)](https://dev.azure.com/rdbartram/GithubPipelines/_build/latest?definitionId=11?branchName=master)
[![latest version](https://img.shields.io/powershellgallery/v/MOFCompare.svg?label=latest+version&style=for-the-badge)](https://www.powershellgallery.com/packages/MOFCompare)
[![downloads](https://img.shields.io/powershellgallery/dt/MOFCompare.svg?label=downloads&style=for-the-badge)](https://www.powershellgallery.com/packages/MOFCompare)



## Installation

MOFCompare is tested to be compatible with Windows PowerShell 5.1 and PowerShell Core 6.x.

Pester comes pre-installed with Windows 10, but we recommend updating, by running this PowerShell command _as administrator_:

```powershell
Install-Module -Name MOFCompare -Force
```

or even better, install it into your profile

```powershell
Install-Module -Name MOFCompare -Scope CurrentUser -Force
```

## Features

### Parsing MOF files

Sometimes its nice to be able to read a MOF file with PowerShell in order to test things or validate during a build etc. The ConvertFrom-MOF will return a Dictionary with all the resources and their properties, nicely organised for you.

### Comparing MOF Files

This is a really powerful feature which basic provides a similar feature to terraform plan but for DSC. You can know what resources have changed or been removed/added between any two MOFs. Its really useful for change management as well as for cleaning up resources after they've been removed.


## Further reading

If you're looking to know more about MOF and DSC generally, there is a great book by Ravikanth Chaganti [Pro PowerShell Desired State Configuration](https://books.google.co.uk/books?id=UUVYDwAAQBAJ).

## Got questions?

Got questions or you just want to get in touch? Use our issues page or one of these channels:

[![Pester Twitter](https://img.icons8.com/color/96/000000/twitter.png)](https://twitter.com/rd_bartram)
