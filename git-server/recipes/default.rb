#
# Cookbook Name:: git_server
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do No
script 'git' do
interpreter "bash"
code <<-EOH
yum install git-all -y
adduser git
cd /opt/git
mkdir project.git
cd project.git
git init --bare

EOH
end