#
# Cookbook Name:: haproxy
# Recipe:: default
#
# 
#
# All rights reserved - Do Not Redistribute
#

package "haproxy"

bash "chkconfig" do
  code <<-EOH
  chkconfig -add haproxy
  chkconfig haproxy on
  EOH
  not_if "chkconfig --list haproxy | grep -ow 'haproxy'"
end

template "/etc/haproxy/haproxy.cfg" do
  source "haproxy.cfg.erb"
  owner "root"
  group "root"
  mode 00644
  action :create
  not_if "cat /etc/haproxy/haproxy.cfg | grep -ow 'listen postfix_haproxy' "
end

service "haproxy" do
  supports :restart => true, :status => true, :reload => true, :start => true
  action [:enable, :start]
end


