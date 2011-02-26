$script:here = split-path $MyInvocation.MyCommand.Definition -parent
push-location "$script:here/.."

& "$script:here/CleanUp.ps1"

$zipExe = "$env:ProgramFiles/7-zip/7z.exe"

& "hg" "update" "release"
$rv = & "hg" "merge" "release" 2>&1

if ($rv.exception -like "*unresolved*") {
	write-host "hg pull --update failed. Take a look." -foreground yellow
	break
}

$targetDir = "./dist/SublimeModelines.sublime-package"

& "python.exe" ".\setup.py" "spa" "--no-defaults"

(resolve-path (join-path `
                    (get-location).providerpath `
                    $targetDir)).path | clip.exe

start-process chrome -arg "https://bitbucket.org/guillermooo/sublimemodelines/downloads"

& "hg" "update" "default"
pop-location