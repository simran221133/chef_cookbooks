#
# Cookbook Name:: openssl
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistri
directory '/root/openssl'
cookbook_file '/root/openssl/openssl.tar.gz' do
  source 'openssl-1.0.2h.tar.gz'
  action :create
end

script 'openssl' do
interpreter "bash"
code <<-EOH
yum groupinstall 'Development Tools' -y
cd /root/openssl
tar -xzf openssl.tar.gz
cd openssl-1.0.2h
sh ./config --prefix=/usr         \
 #        --openssldir=/etc/ssl \
  #       --libdir=lib          \
   #      shared                \
    #     zlib-dynamic &&
make depend           &&
make
EOH
end