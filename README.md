# Remote-LaTeX-Compile

Windows has the problem that it is not really performant when compiling LaTeX projects. This is a short CLI to compile a latex project on a remote (preferably) Linux server.

## How to use
Start the remoteCompile.ps1 powershell script in the folder of your git repository

    usage: remoteCompile [-help] [-clean] [-files <paths>]

        -help           lists this help
        -clean          cleans the Compile folder from tmp files and recompiles the LaTeX project
        -files <paths>  only uploads the given files (seperated by ',')
                        the paths are relative to the remoteCompile script
        -fullUpload     uploads all files




## Settings
You have to set the following setting / magic numbers in remoteCompile.ps1:

    $installationPathWinSCP = "C:\Program Files\WinSCP\WinSCPnet.dll" #path for winscp ddl
    $pathGitRepository = "C:\Users\JSchmiegel\Documents\GitProject" #path of the git repository of the LaTeX project
    $pathLaTeXProject = "C:\Users\JSchmiegel\Documents\GitProject\Arbeit\" #path of the LaTeX project (has to be part of the path of the git repository)
    $nameDocument = "main.pdf" #filename of the latex pdf document
    $compileHost = "127.0.0.1" #name/ip-adress of the compile server
    $compileHostUsername = "admin" #username of the user who compiles/uploads
    $pathPrivatSshKey = "C:\Users\JSchmiegel\.ssh\adminpriv.ppk" #path of the private ssh key
    $compileHostKeyFingerprint = "ssh-ed25519 255 ns0JzdwwsByT2fAioJok1Rlra2YUlkToS6II7XhW+fU=" #sshKeyFingerprint

## Requirements
+ remote (linux) server
+ ssh key to connect to the remote server (see: [Set up SSH public key authentication](https://winscp.net/eng/docs/guide_public_key))
+ `Compile` Folder in the home directory
    + copy `compile.ps1` into the `Compile` Folder
    + copy `clean.ps1` into the `Compile` Folder
+ WinSCP installed on the client ([WinSCP Homepage](https://winscp.net/eng/index.php))
+ all needed latex packages installed on the remote server
+ set settings
