# start this script in PS to import and start the project module
# usage: $PSHOME\powershell.exe -NoExit ". .\ps-profile $MyInvocation.MyCommand.Source"

# $env:VisualStudioVersion="15.0" # uncomment for VS2017, or change to other versions...used in vstools.ps1

# this seems to only work properly if not defined in the basic-project module
function Restart-Workspace([switch] $nohelp, [switch] $hard) {
    if ($nohelp) {
        $env:SHOW_HELP = "NO"
    }
    if ($hard) {
        $global:workspace.clearWorkspace()
    }
    switch ($args[0]) {
	    Default {}
    }

    remove-module "basic-project"
    import-module "$PSroot\template\basic-project"
}

if (Test-Path "ps-profile-$env:COMPUTERNAME.ps1") {
	. ".\ps-profile-$env:COMPUTERNAME.ps1"
}
if (Test-Path "ps-profile-$env:USERNAME.ps1") {
	. ".\ps-profile-$env:USERNAME.ps1"
}

import-module $args[0]
