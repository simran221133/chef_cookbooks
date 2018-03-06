
Install-WindowsFeature -name FS-Resource-Manager, FS-DFS-Namespace, FS-DFS-Replication, RSAT-DFS-Mgmt-con, RSAT-FSRM-Mgmt


$credential = New-Object System.Management.Automation.PsCredential("hcl\administrator", (ConvertTo-SecureString "Admin098" -AsPlainText -Force))
                       
Add-Computer -DomainName  domain -Credential $credential

#restart-computer


