 <#
.SYNOPSIS
ZBX_WIN_XXX_GetLastUpdateDate.ps1 - script gets the last date of patch installation.

.DESCRIPTION 
Script leverages the "win32_quickfixengineering" WMI class, it gets only records telling that the patch has been installed and sorts bythe date (InstalledON) taking the newest's row value.

.OUTPUTS
Date in yyyy-MM-dd format

.EXAMPLE
ZBX_WIN_XXX_GetLastUpdateDate.ps1

Change Log
V1.0,   28.01.2020 (Pawel Jarosz)
#>

Get-Date (((get-wmiobject -class win32_quickfixengineering) | sort InstalledOn | select -Last 1).InstalledOn) -Format "yyyy-MM-dd"