# Cookbook Name:: bugzilla
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "httpd" do
  action :install
end
service "httpd" do
  action [:enable, :start]
end

package "mysql" do
action :install
end
package "mysql-server"
package "mysql-libs"
package "mysql-server"

