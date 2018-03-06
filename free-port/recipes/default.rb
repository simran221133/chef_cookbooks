#
# Cookbook Name:: AMI
# Recipe:: default
#
# 
#

script 'port' do
interpreter "bash"
code <<-EOH
myport=80
# count the number of occurrences of port $myport in output: 1= in use; 0 = not in use
result=$(ss -ln src :$myport | grep -Ec -e $myport)
if [ "$result" -eq 1 ]; then
  echo "Port $myport is in use (result == $result) "
else
  echo "Port $myport is NOT in use (result == $result) "
fi
EOH
end