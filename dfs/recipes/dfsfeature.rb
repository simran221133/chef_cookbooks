#
# Cookbook Name:: dfs
# Recipe:: dfsfeature
#
# 
#
# All rights reserved - Do Not Redistribute
#


if node['dfs']['os']=="linux"
  print('DFS is not for Linux')
end

if node['dfs']['os']=="windows"
  powershell_script "enable DFS Feature" do
    code <<-EOH
      Install-WindowsFeature -name FS-Resource-Manager, FS-DFS-Namespace, FS-DFS-Replication, RSAT-DFS-Mgmt-con, RSAT-FSRM-Mgmt
    EOH
  end
end
