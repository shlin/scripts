# 撈 VMHost 設定

Import-Module VMware.PowerCLI.VCenter
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -Confirm:$false
Set-PowerCLIConfiguration -InvalidCertificateAction:Ignore -Confirm:$false
Connect-VIServer -Server tesxivc01.obuat.corp

$resultData = @{}

Get-VMHost | ForEach-Object{
    $current = $_
    $currentView = $_ | Get-View
    $entity = @{
        Hostname = $current.Name
        PasswordMaxDays = ($current | Get-AdvancedSetting 'Security.PasswordMaxDays').Value
        PasswordHistory = ($current | Get-AdvancedSetting 'Security.PasswordHistory').Value
        LockdownMode = (Get-View $currentView.ConfigManager.HostAccessManager).LockdownMode
    }

    $resultdata[$current.Name] = $entity
}

$resultData.Values | Select-Object Hostname, PasswordMaxDays, PasswordHistory, LockdownMode  | ConvertTo-Csv
