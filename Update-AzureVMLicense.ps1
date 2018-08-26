<#
.SYNOPSIS
This module is to update the licenses of Virtual Machines within Azure to Windows Server licneses.
.DESCRIPTION
The user logs into Azure and the script will run through all of the resource groups and their virtual machones to update the licenses.
.PARAMETER Machine
This is the name of the machine you want to change the license to.
.PARAMETER ResourceGroup
This is the name of the resource group of all the Virtual machines that you want to change.
.PARAMETER UpdateAll
This is the switch that will go through all user subscriptions and resource groups and change the licenses to Windows Server.
#>
function Update-AzureVMLicense
{
	
	param (
		[Parameter][string]$Machine,
		[string]$ResourceGroup,
		[switch]$UpdateAll
	)
	BEGIN
	{
		Login-AzureRmAccount
	}
	PROCESS
	{
		
		if ($Machine)
		{
			Write-Host "Updating $($machine.Name) in $($group.ResourceGroupName)"
			#Find the machine
			$wvm = Get-AzureRmVM -ResourceGroupName $ResourceGroup -Name $Machine
			#Set the license
			$wvm.LicenseType = "Windows_Server"
			#Update the Machine
			Update-AzureRmVM -ResourceGroupName $group.ResourceGroupName -VM $wvm
		}
		
		if ($UpdateAll)
		{
			$u = Read-Host "This function will go through every subscription and change their license to Windows Server. Enter Y to confirm"
			if ($u.ToLower() -eq "y")
			{
				#Get all of the subscriptions
				$allSubs = Get-AzureRmSubScription
				#Go through each subscription
				foreach ($sub in $allSubs)
				{
					$resourceGroups = Get-AzureRmResourceGroup
					$count = 0;
					$machines = @();
					foreach ($group in $resourceGroups)
					{
						#Get all of the VMs
						$ret = Get-AzureRMVm -ResourceGroupName $group.ResourceGroupName
						if ($ret)
						{
							Write-Host "Found $($ret.Length) machines in $($group.ResourceGroupName)"
							foreach ($machine in $ret)
							{
								if (-not ($machine.LicenseType -eq "Windows_Server"))
								{
									$count++
									$machines += $machine
									Write-Host "Updating $($machine.Name) in $($group.ResourceGroupName)"
									$wvm = Get-AzureRmVM -ResourceGroupName $group.ResourceGroupName -Name $machine.Name
									$wvm.LicenseType = "Windows_Server"
									Update-AzureRmVM -ResourceGroupName $group.ResourceGroupName -VM $wvm
								}
								else
								{
									Write-Host "$($machine.Name) already has a  Windows Server License"
								}
							}
						}
						else
						{
							Write-Host "No VMS found in $($group.ResourceGroupName)"
						}
					}
				}
			}
			else
			{
				Write-Host "Exiting Process"
				Exit
				
			}
		}
		
		if ($ResourceGroup)
		{
			$rg = Get-AzureRmResourceGroup -Name $ResourceGroup
		}
		else
		{
			$rg = Get-AzureRmResourceGroup
		}
		$count = 0;
		$machines = @();
		foreach ($group in $resourceGroups)
		{
			$ret = Get-AzureRMVm -ResourceGroupName $group.ResourceGroupName
			if ($ret)
			{
				Write-Host "Found $($ret.Length) machines in $($group.ResourceGroupName)"
				foreach ($machine in $ret)
				{
					if (-not ($machine.LicenseType -eq "Windows_Server"))
					{
						$count++
						Write-Host "Updating $($machine.Name) in $($group.ResourceGroupName)"
						$wvm = Get-AzureRmVM -ResourceGroupName $group.ResourceGroupName -Name $machine.Name
						$wvm.LicenseType = "Windows_Server"
						Update-AzureRmVM -ResourceGroupName $group.ResourceGroupName -VM $wvm
						$machines += $wvm
					}
					else
					{
						Write-Host "$($machine.Name) already has a  Windows Server License"
					}
				}
			}
			else
			{
				Write-Host "No VMS found in $($group.ResourceGroupName)"
			}
		}
		
	}
	END
	{
		$date = Get-Date -UFormat "%Y-%m-%d"
		$machines | Export-Csv -Path "$($date)-AzureUpdate.csv"
		Write-Host "Updated the license of $($count) machines"
	}
}

Update-AzureVMLicense 