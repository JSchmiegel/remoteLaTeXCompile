param (
    [switch] $help,
    [switch] $clean,
    [string[]] $files
)
###########################



# Settings
$installationPathWinSCP = "C:\Program Files\WinSCP\WinSCPnet.dll" #path for winscp ddl
$pathGitRepository = "C:\Users\JSchmiegel\Documents\GitProject" #path of the git repository of the LaTeX project
$pathLaTeXProject = "C:\Users\JSchmiegel\Documents\GitProject\Arbeit\" #path of the LaTeX project (has to be part of the path of the git repository)
$nameDocument = "main.pdf" #filename of the latex pdf document
$compileHost = "127.0.0.1" #name/ip-adress of the compile server
$compileHostUsername = "admin" #username of the user who compiles/uploads
$pathPrivatSshKey = "C:\Users\JSchmiegel\.ssh\adminpriv.ppk" #path of the private ssh key
$compileHostKeyFingerprint = "ssh-ed25519 255 ns0JzdwwsByT2fAioJok1Rlra2YUlkToS6II7XhW+fU=" #sshKeyFingerprint


###########################

function gitUpload() {
    foreach ($item in (git status --porcelain)) {
        $item = $item -creplace "( *(\?|M|A) +)", ""
        $session.PutFiles($pathGitRepository + $item.Replace("/", "\"), "/home/" + $compileHostUsername + "/Compile/" + ($item).Replace($pathExtensionLaTeXProject, "")).Check()
        Write-Host $item
    }
}

function fileUpload($path) {
    $item = $path.Replace(".\", "")
    $session.PutFiles($pathLaTeXProject + $item.Replace("/", "\"), "/home/" + $compileHostUsername + "/Compile/").Check()
    Write-Host $item
}

function remoteCompile {
    ssh $compileHostUsername@$compileHost ("cd /home/" + $compileHostUsername + "/Compile/ && pwsh ./compile.ps1")
}

function remoteClean {
    ssh $compileHostUsername@$compileHost ("cd /home/" + $compileHostUsername + "/Compile/ && pwsh ./clean.ps1")
}

function createSFTPSession{
    
    
    # Setup session options
    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
        Protocol              = [WinSCP.Protocol]::Sftp
        HostName              = $compileHost
        Username              = $compileHostUsername
        SshHostKeyFingerprint = $compileHostKeyFingerprint
        SshPrivateKeyPath     = $pathPrivatSshKey
        
    }
    
    # $session = New-Object WinSCP.Session
    $session.Open($sessionOptions)
}

function getPDF {
    # Transfer files
    $session.GetFiles("/home/" + $compileHostUsername + "/Compile/" + $nameDocument, $pathLaTeXProject + "*").Check()
}

#main
$pathExtensionLaTeXProject = $pathLaTeXProject.Replace($pathGitRepository, "").Replace("\","/")  
Add-Type -Path $installationPathWinSCP
$session = New-Object WinSCP.Session
try {
    if ($help) {
        Write-Host ""
        Write-Host "usage: remoteCompile [-help] [-clean] [-files <paths>]"
        Write-Host ""
        Write-Host "    -help           lists this help"
        Write-Host "    -clean          cleans the Compile folder from tmp files and recompiles the LaTeX project"
        Write-Host "    -files <paths>  only uploads the given files (seperated by ',')"
        Write-Host "                    the paths are relative to the remoteCompile script"
        Write-host ""
    }elseif ($clean){
        remoteClean
        remoteCompile
    }
    else{
        createSFTPSession
        $stopwatch = New-Object System.Diagnostics.Stopwatch
        $stopwatch.Start()
        if($files){
            foreach ($file in $files) {
                fileUpload($file)
            }
        }else {
            gitUpload
        }
        remoteCompile
        getPDF
        Write-Host "Remote-Executed:" 
        $stopwatch.Stop()
        $stopwatch
    }
}
catch {
    Write-Host $_.Exception
    Write-Host $_.ErrorDetails
}
finally{
    $session.Dispose()
}