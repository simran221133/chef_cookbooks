#
# Cookbook Name:: samba
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "samba"
service "smb" do
 action [:enable, :start]
end
package "sed"
script 'samba' do
 interpreter "bash"  
code <<-EOH
 sed -i '/workgroup = group/ c workgroup = workgroup' /etc/samba/smb.conf
if[ `$(grep -w "[ShareFolder]" /etc/samba/smb.conf) ne 0` ] 
then
echo -e "[ShareFolder]\ncomment = Insert a comment here\npath = /newdirtest/\nvalid users = Admin\npublic = yes\nwritable = yes\nprintable = no\ncreate mask = 0765\nbrowseable = yes" >> /etc/samba/smb.conf 
#useradd -c "somya tayal" Admin
#echo "Admin098" | smbpasswd -a Admin --stdin
fi
service smb restart 
EOH
end