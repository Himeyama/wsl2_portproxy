$dir = "${env:HOMEPATH}\AppData\Local\wsl2_portproxy"
$path = [Environment]::GetEnvironmentVariable("PATH", "User")
$path += ";$dir"
[Environment]::SetEnvironmentVariable("PATH", $path, "User")
mkdir $dir\ -Force | Out-Null
cp .\wsl2_portproxy.ps1 $dir\