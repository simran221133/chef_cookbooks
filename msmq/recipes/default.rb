#
# Cookbook Name:: msmq
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
 directory 'C:/msmq' do
  owner 'Administrator'
  action :create
end
cookbook_file 'C:/msmq/msmq.ps1' do
  source 'msmq.ps1'
  action :create
end
#execute 'check' do
#command 'C:/Windows/System32/WindowsPowerShell/v1.0/powershell_ise.exe  $env:PSModulePath'
#end
execute 'msmq' do
command 'C:/Windows/System32/WindowsPowerShell/v1.0/powershell_ise.exe -file  C:/msmq/msmq.ps1'
end
