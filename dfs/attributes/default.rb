#
# Cookbook Name:: dfs
# Attribute:: default
#
# Copyright 2013, News UK
#
# All rights reserved - Do Not Redistribute
#

if kernel['name']=="Linux"
default['dfs']['os']="linux"
else
default['dfs']['os']="windows"
end


default['dfs']['hostname']=''
default['dfs']['domainname']=''
default['dfs']['username']='administrator'
default['dfs']['password']='#############'