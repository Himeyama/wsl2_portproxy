$dir = "${env:systemdrive}${env:HOMEPATH}\AppData\Local\wsl2_portproxy"

if(!(($env:PATH -split ";").contains("C:${env:HOMEPATH}\AppData\Local\wsl2_portproxy"))){
    $path = [Environment]::GetEnvironmentVariable("PATH", "User")
    $path += ";$dir"
    [Environment]::SetEnvironmentVariable("PATH", $path, "User")
}
mkdir $dir\ -Force | Out-Null
$pwd = Convert-Path .
cp "${pwd}\wsl2_portproxy.ps1" "${dir}\"