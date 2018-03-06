#
# Cookbook Name:: rabbitmq
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#package "rabbitmq-server"
#service "rabbitmq-server" do
#action [:enable, :start]
#end
directory '/rabbitmq' do
action :create
end
cookbook_file '/rabbitmq/socat.rpm' do
  source 'socat-1.7.1.3-1.el6.rf.x86_64.rpm'
  action :create
end 
cookbook_file '/rabbitmq/erlang.rpm' do
  source 'erlang.rpm'
  action :create
end 

cookbook_file '/rabbitmq/rabbitmq-server.rpm' do
  source 'rabbitmq-server.rpm'
  action :create
end 
yum_package '/rabbitmq/erlang.rpm'
yum_package '/rabbitmq/socat.rpm'
yum_package '/rabbitmq/rabbitmq-server.rpm' 
script 'rabbitmq' do
 interpreter "bash"  
code <<-EOH
chkconfig rabbitmq-server on
/sbin/service rabbitmq-server start
EOH
end