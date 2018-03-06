Description
===========
This cookbook installs and configures the dfs feature on the node and adds the node to the domain.

Supported Platforms
-------------------
1. Windows server 2012

Attributes
----------
- `default['dfs']['hostname']=''`
	- Hostname of the node.
- `default['dfs']['domainname']=''`
	- Domain name of the node.
- `default['dfs']['username']='administrator'`
	- Username of the node.
- `default['dfs']['password']='#############'`
	- Password of the node.

	Recipes
-------
###dfs::dfsfeature

```ruby
	powershell_script "enable DFS Feature" do
	    code <<-EOH
	      Install-WindowsFeature -name FS-Resource-Manager, FS-DFS-Namespace, FS-DFS-Replication, RSAT-DFS-Mgmt-con, RSAT-FSRM-Mgmt
	    EOH
	    not_if "(Powershell.exe -command \"If ((Get-WindowsFeature -name FS-Resource-Manager, FS-DFS-Namespace, FS-DFS-Replication, RSAT-DFS-Mgmt-con, RSAT-FSRM-Mgmt).Installed).count -eq 5) {EXIT 0} else {EXIT 1}\" )"
	end
```
- `powershell_script` resource is used for dfs feature installation.
- `code` block contains the powershell scripts to install all the necessary features needed for dfs
- `not_if` condition is used for idempotency to check if the features has already been installed of not.

###dfs::domainjoin
```ruby
	powershell_script "hostname and domain join" do
	   code <<-EOH
	        Rename-Computer "#{node['dfs']['hostname']}"
	        $credential = New-Object System.Management.Automation.PsCredential("#{node['dfs']['domainname']}\\#{node['dfs']['username']}",(ConvertTo-SecureString "#{node['dfs']['password']}" -AsPlainText -Force))
	        Add-Computer -DomainName "#{node['dfs']['domainname']}" -NewName "#{node['dfs']['hostname']}" -Credential $credential
	        Restart-Computer -Force
	      EOH
	   not_if {node['hostname'] == "#{node['dfs']['hostname']}".upcase}
	end
```
- `powershell_script` resource is used for domain join
- `code` block will rename the node with the attribute value provided and adds the node to a domain using the attribute values mentioned.
- `not_if` condition checks if the node is joined to the specified domain or not using the `node['dfs']['hostname']` attribute.

Usage
-----

####dfsfeature

The `dfsfeature` recipe installs dfs feature on a windows node.This recipe does not have any attributes associated to it. Add `recipe[dfs::dfsfeature]` to the nodes run list. 

	recipe['dfs::domainjoin']

####dfs::domainjoin
The `domainjoin` recipe changes the hostname and joins the  node to a domain.Set the attribute value in the `attributes/default.rb` file and add `recipe[dfs::domainjoin]` to the nodes run list. 

	recipe['dfs::domainjoin']
Attributes can also be passed using a json file from the node during the chef client run.

	chef-client -j node,json
	
	
#### Example `node.json`

	{
	  "name": “dfs”,
	  "description": "dfs domain join",
	  “dfs” : {
	  “hostname” : “<TagHostname Value comes here>”,
	  “domainname” : “<domain name here>”,
	  “username” : “<username here>”’
	  “password” : “<password here>”
	},
	  "run_list": [“role[dfs2012]”]	  
	}

	License and Authors
-------------------
Authors: Suraj Savita
#
contributors: Bibin W

Copyright:: News UK Pvt. Ltd.