# Function to check if the script is running as Administrator
function Test-IsAdministrator {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Function to show RSAT menu
function Show-RSATMenu {
    Write-Host "List of RSAT Tools:"
    foreach ($tool in $rsatTools) {
        $capability = Get-WindowsCapability -Online | Where-Object { $_.Name -eq $tool.Command }
        if ($capability -and $capability.State -eq 'Installed') {
            Write-Host "$($tool.Number). $($tool.Name) [Already Installed]" -ForegroundColor Green
        } else {
            Write-Host "$($tool.Number). $($tool.Name)" -ForegroundColor White
        }
    }
    Write-Host "20. Go back to main menu" -ForegroundColor White
}

# Function to install RSAT tool
function Install-RSATTool {
    param (
        [int]$toolNumber
    )
    if ($toolNumber -eq 20) {
        return "back"
    }

    $selectedTool = $rsatTools | Where-Object { $_.Number -eq $toolNumber }
    if ($selectedTool) {
        $capability = Get-WindowsCapability -Online | Where-Object { $_.Name -eq $selectedTool.Command }
        if ($capability -and $capability.State -eq 'Installed') {
            Write-Host "$($selectedTool.Name) is already installed." -ForegroundColor Yellow
        } else {
            Write-Host "Installing $($selectedTool.Name)..." -ForegroundColor Cyan
            Add-WindowsCapability -Online -Name $selectedTool.Command
            Write-Host "$($selectedTool.Name) installed successfully." -ForegroundColor Green
        }
    } else {
        Write-Host "Invalid selection. Please try again." -ForegroundColor Red
    }
    return "continue"
}

# Function to remove RSAT tool
function Remove-RSATTool {
    param (
        [int]$toolNumber
    )
    if ($toolNumber -eq 20) {
        return "back"
    }

    $selectedTool = $rsatTools | Where-Object { $_.Number -eq $toolNumber }
    if ($selectedTool) {
        $capability = Get-WindowsCapability -Online | Where-Object { $_.Name -eq $selectedTool.Command }
        if ($capability -and $capability.State -eq 'Installed') {
            Write-Host "Removing $($selectedTool.Name)..." -ForegroundColor Cyan
            Remove-WindowsCapability -Online -Name $selectedTool.Command
            Write-Host "$($selectedTool.Name) removed successfully." -ForegroundColor Green
        } else {
            Write-Host "$($selectedTool.Name) is not installed." -ForegroundColor Yellow
        }
    } else {
        Write-Host "Invalid selection. Please try again." -ForegroundColor Red
    }
    return "continue"
}

# Main function
function Main {
    Write-Host "Welcome to RSAT toolbox!" -ForegroundColor Cyan

    if (-not (Test-IsAdministrator)) {
        Write-Host "This script needs to be run as an Administrator. Please run it with elevated privileges." -ForegroundColor Red
        exit
    }

    do {
        $action = Read-Host "Do you want to install or remove RSAT tools? Enter 'i' for install, 'r' for remove, or 'e' to exit"
        if ($action -eq 'i') {
            do {
                Show-RSATMenu
                $userInput = [int](Read-Host "Enter the number of the RSAT tool to install or 20 to go back to main menu")
                $result = Install-RSATTool -toolNumber $userInput

                if ($result -eq "back") {
                    break
                }

                $continue = Read-Host "Do you want to perform another action? (y/n)"
            } while ($continue -eq 'y')
        } elseif ($action -eq 'r') {
            do {
                Show-RSATMenu
                $userInput = [int](Read-Host "Enter the number of the RSAT tool to remove or 20 to go back to main menu")
                $result = Remove-RSATTool -toolNumber $userInput

                if ($result -eq "back") {
                    break
                }

                $continue = Read-Host "Do you want to perform another action? (y/n)"
            } while ($continue -eq 'y')
        } elseif ($action -eq 'e') {
            Write-Host "Thank you very much for using this tool." -ForegroundColor Cyan
            exit
        } else {
            Write-Host "Invalid selection. Please enter 'i' to install, 'r' to remove, or 'e' to exit." -ForegroundColor Red
        }
    } while ($true)
    Write-Host "Thank you very much for using this tool." -ForegroundColor Cyan
}

# Define the list of RSAT tools
$rsatTools = @(
    @{ Number = 1; Name = "Active Directory Domain Services and Lightweight Directory Tools"; Command = "Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0" },
    @{ Number = 2; Name = "BitLocker Drive Encryption Administration Utilities"; Command = "Rsat.BitLocker.Recovery.Tools~~~~0.0.1.0" },
    @{ Number = 3; Name = "DHCP Server Tools"; Command = "Rsat.Dhcp.Tools~~~~0.0.1.0" },
    @{ Number = 4; Name = "DNS Server Tools"; Command = "Rsat.Dns.Tools~~~~0.0.1.0" },
        @{ Number = 5; Name = "Failover Clustering Tools"; Command = "Rsat.FailoverCluster.Management.Tools~~~~0.0.1.0" },
    @{ Number = 6; Name = "File Services Tools"; Command = "Rsat.FileServices.Tools~~~~0.0.1.0" },
    @{ Number = 7; Name = "Group Policy Management Tools"; Command = "Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0" },
    @{ Number = 8; Name = "IP Address Management (IPAM) Client"; Command = "Rsat.IPAM.Client.Tools~~~~0.0.1.0" },
    @{ Number = 9; Name = "Network Controller Management Tools"; Command = "Rsat.NetworkController.Tools~~~~0.0.1.0" },
    @{ Number = 10; Name = "Network Load Balancing Tools"; Command = "Rsat.NLB.Tools~~~~0.0.1.0" },
    @{ Number = 11; Name = "Remote Access Management Tools"; Command = "Rsat.RemoteAccess.Management.Tools~~~~0.0.1.0" },
    @{ Number = 12; Name = "Remote Desktop Services Tools"; Command = "Rsat.RemoteDesktop.Services.Tools~~~~0.0.1.0" },
    @{ Number = 13; Name = "Server Manager"; Command = "Rsat.ServerManager.Tools~~~~0.0.1.0" },
    @{ Number = 14; Name = "Shielded VM Tools"; Command = "Rsat.Shielded.VM.Tools~~~~0.0.1.0" },
    @{ Number = 15; Name = "Storage Migration Service Management Tools"; Command = "Rsat.StorageMigrationService.Management.Tools~~~~0.0.1.0" },
    @{ Number = 16; Name = "Storage Replica Tools"; Command = "Rsat.StorageReplica.Tools~~~~0.0.1.0" },
    @{ Number = 17; Name = "System Insights Tools"; Command = "Rsat.SystemInsights.Management.Tools~~~~0.0.1.0" },
    @{ Number = 18; Name = "Volume Activation Management Tools"; Command = "Rsat.VolumeActivation.Tools~~~~0.0.1.0" },
    @{ Number = 19; Name = "Windows Server Update Services Tools"; Command = "Rsat.WSUS.Tools~~~~0.0.1.0" }
)

# Start the main function
Main

