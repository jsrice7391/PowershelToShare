# PowershellToShare
I work with Powershell a lot. These are some tools that I use that you can use too.

## Table of Contents
#### Update-AzureVMLicense.ps1
Goes through all of the resource groups and rolls the virtual machine license to Windows_Server, enabling Azure Hbrid solution.

#### New-DomainToSPOSIte
Some companies have vendors come in who need access to certain resources on either Azure or Sharepoint-Online. This script goes, adds a domain to accepted domains, go and emails the new users, then goes to a specific Sharepoint online site and sets its sharing credentials to allow those users as collaborators.

