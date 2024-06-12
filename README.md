# RSAT Toolbox

### How to use

1. Open PowerShell via Administrator and paste the following command.
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aice09/rsat-toolbox/main/RSAT-Toolbox.ps1" -OutFile "$($Env:TEMP)\RSAT-Toolbox.ps1"; & "$($Env:TEMP)\RSAT-Toolbox.ps1";
```
### Note:
- If running script is disabled on the device, run the following command:
```powershell
Set-ExecutionPolicy RemoteSigned
```
or for more security, use this to allow only to run script during the current session.
```powershell
Set-ExecutionPolicy RemoteSigned -Scope Process
```
To know more about RSAT visit https://learn.microsoft.com/en-us/troubleshoot/windows-server/system-management-components/remote-server-administration-tools.
