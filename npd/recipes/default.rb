# Cookbook Name:: npd
# Recipe:: default
#
#
# All rights reserved - Do Not Redistribute
#

package "dracut-fips" do
        action :install
end

package "libgcrypt" do
        action :install
end

package "nss-tools" do
        action :install
end

package "openswan" do
        action :install
end

package "openssh-clients" do
        action :install
end

package "openssh-server" do
        action :install
end
package "openssl" do
        action :install
end

package "mysql-server" do
        action :install
end

bash "Setting Up FIPS" do
        user "root"
        cwd "/tmp"
        code <<-EOH
                sed -i "s/PRELINKING=.*/PRELINKING=no/" /etc/sysconfig/prelink
                prelink -u -a
                sed -i '/kernel/s/$/ fips=1/g' /boot/grub/menu.lst
                mkdir -p /boot/oldimages/
                cp -f /boot/*.img /boot/oldimages/
                dracut -v -f
                reboot
        EOH
                not_if "ls -ld /boot/oldimages/"
end
