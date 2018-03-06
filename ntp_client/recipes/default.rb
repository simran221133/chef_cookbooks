# Cookbook Name:: _client
# Recipe:: default
#
#
# All rights reserved - Do Not Redistribute
#

if node['os'] == 'linux'
  case node[:platform]
    when "ubuntu","debian"
      package "ntp" do
        action :install
      end
      package "ntpdate" do
        action :install
      end
  end

  service "NTP Service" do
    case node["platform"]
      when "redhat","centos","amazon"
        service_name "ntpd"
      when "suse","ubuntu","debian"
        service_name "ntp"
    end
    action [ :enable, :start ]
  end
end