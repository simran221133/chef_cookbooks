#
# Cookbook Name:: AMI
# Recipe:: default
#
# 
#
# All rights reserved - Do Not Redistribute
#

bash "Create Files" do
  user "root"
  cwd  "/root"
  code <<-EOH
  touch ami_output.log
  touch ami_error.log
  EOH
   not_if {File.exists?("/root/ami_output.log") }
end


bash "Create AMI" do
  user "root"
  cwd  "/root"
  code <<-EOH
  ami_date=`date +%d/%m/%Y-%H-%M-%S`
  name = node['ami']['Name']
  My_Instance_ID=`/usr/bin/curl --silent http/latest/meta-data/instance-id`
  aws ec2 create-image --instance-id $My_Instance_ID --name "#{node['ami']['Name']}_${ami_date}" --description "#{node['ami1']['Desc']}" --region eu-west-1 > /root/ami_output.log 2>/root/ami_error.log
  EOH
   only_if {File.zero?("/root/ami_output.log") }
end