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

function RebuildEnvironment {
    setting vsts  https://dx-fx.visualstudio.com/DefaultCollection/Home/_git/PSRoguelike

}

Add-Help WEB "web" "Get-Web" "e.g., 'web github', 'web docs', 'web issues'"
function Get-Web { 
	if ($args.Count -eq 0) {
        (setting).GetEnumerator() | 
            Where-Object {$_.value.tostring().startsWith("http")} | 
            ForEach-Object {$_.Name}
	} else {
		Start-Process (settings $args[0])
	}	
}

Add-Help GIT "" "Add-Origin -url -name" "create 'origin' remote, e.g., 'Add-Origin github https://github.com/user/project.git'"
function Add-Origin($name, $url) { Add-Remote "origin" $url $name}
#function Add-Github($url) { Add-Remote "github" $url "github"}
Add-Help GIT "" "Add-Remote -remote -url -name" "e.g., 'Add-Remote origin github https://github.com/user/project.git'"
function Add-Remote($remote, $url, $name) {
    if (!$remote) {
        $remote = Read-Host "What is the remote? E.g., origin, upstream, etc. [origin] is the default"
    }
    if (!$name) {
        $name = Read-Host "[OPTIONAL] What is the friendly name of the repository provider? E.g., GitHub, VSTS, etc."
        if ($name){
            $msg = " in $name"
        }
    }
    if (!$url) {
        "Create an empty repo$msg and then enter the url (e.g. https://github.com/user/project.git)" | WARNING
        $url = Read-Host "Repo URL"
    }   
    if ($url){
        if (!$remote) {
            $remote = "origin"
        }
        #Set the new remote
        git remote add $remote $url
        # Verify the new remote URL
        if (git remote -v | Where-Object {$_.contains($url)}){
            "Success! Type 'push' to upload your commits" | GOOD
        }
        if ($name) {
            $page = $url.Replace(".git","")
            setting $name $page
            "type: 'web $name' to go to: $page" | GOOD
        }     
    }
}
