<#
    basic-project supports multiple projects, which may be grouped and kept in sync (e.g. branch checkout).

    This script is loaded by basic-project, the idea is to apply customization for your particular project(s).
    For instance, additional powershell functions loaded and defined to support APPX, Testing, 
    and the particulars of of deployment.

    ps-profile can configure settings for the particular MACHINE and/or USER
#>

# TODO: uncomment any of the following to include features
#. "$PSroot\objects\devop.ps1"           # support to create workflow recipes
#. "$PSroot\objects\appx.ps1"            # APPX support

if (Test-Path "ps-start-$env:COMPUTERNAME.ps1") {
    . ".\ps-start-$env:COMPUTERNAME.ps1"
}
if (Test-Path "ps-start-$env:USERNAME.ps1") {
    . ".\ps-start-$env:USERNAME.ps1"
}

#region Overloads
# function Start-Test {
# 	settings msTestSuccess $true
# }

# Target Info-Overrides {
#	"Approve-ReleaseBuildSuccess" | GOOD
#	"Info-ApproveHealth" | GOOD
#	"Info-DeployHealth" | GOOD
#}

#endregion

