#cookbook_file '/newdirtest/mysql' do
  #source ''
 # action :create
#end
package "mysql" do
action :install
end
package "mysql-server"
package "mysql-libs"
package "mysql-server"
#package "telnet"
#package "ftp"
service "mysqld" do
 action [:enable, :start]
end
#script 'mysql' do
#interpreter "bash"
#code <<-EOH
#mysql -e "UPDATE mysql.user SET Password = PASSWORD('Admin098') WHERE User = 'root'"
#EOH
#end
#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
