haproxy Cookbook
================
This cookbook installs and configures haproxy on a node along with AWS ec2 and autoscaling cli's.

Requirements
------------
1. Awscli cookbook - Dependency


Supported Platforms
------------------

1.RHEL

Attributes
----------
- `default['haproxy']['balance_algorithm'] = "roundrobin"`
	- Sets the haproxy balance algorithm. By default it is set to rounrobin. Other options are leastconn, source, uri etc,,
- `default['haproxy']['mode'] = "tcp"`
	- Haproxy mode is set to tcp by default.
- `default['HAProxy']['postfixASG'] = ""`
- `default['HAProxy']['region']= node['awscli']['region']`

Recipes
-----
###default
Defaullt recipe installs and configures haproxy.

###Include Recipes
```ruby
	include_recipe "awscli::pkgsetup"
	include_recipe "awscli::ec2cli"
	include_recipe "awscli::autoscalingcli"
```
awscli recipes are included in the default recipe. These recipes are taken from the awscli cookbook. dependency has to be mentioned in the `metadata.rb` file inorder to include those recipes.

###SendMail Shutdown
```ruby
	bash 'Sendmail Shutdown' do
	  flags '-xv'
	  code <<-EOH
	    if [ `rpm -qa | grep sendmail | wc -l` -ne 0 ] ; then
	      echo " SENDMAIL IS ALREADY INSTALLED LET'S SHUT IT DOWN FOREVER. "
	      chkconfig sendmail off
	      service sendmail stop
	    fi
	  EOH
	  only_if "ss -alnp | grep ':25' | grep -wo 'sendmail'"
	  action :run
	end
```
- `bash` resource shutdown the sendmail option using bash code block. This resource will get executed only if it meets the condition specified int the `only_if` condition.

###package "haproxy"
package resource will install haproxy from the repository.
```ruby
	bash "chkconfig" do
	  code <<-EOH
	  chkconfig -add haproxy
	  chkconfig haproxy on
	  EOH
	  not_if "chkconfig --list haproxy | grep -ow 'haproxy'"
	end
```
- `bash` resource will add haproxy to the system startup using `chkconfig` option. `not_if` condition check if haproxy is already on the chkconfig list, so that it wont get executed in successive chef-client runs.

###Configure Haproxy
```ruby
	template "/etc/rsyslog.d/haproxy.conf" do
	  source "haproxy.conf.erb"
	  owner "root"
	  group "root"
	  mode 00644
	  action :create_if_missing
	end
```
- `template ` resource will replace the content of `haproxy.conf` from the source file mentioned in the template.

###Configure logging for Haproxy
```ruby
	bash 'Configure Logging for HAProxy' do
	  flags '-xv'
	  cwd '/root'
	  code <<-EOH
	    sed -i 's/\#\\$ModLoad imudp/\\$ModLoad imudp/' /etc/rsyslog.conf
	    sed -i 's/\#\\$UDPServerRun 514/\\$UDPServerRun 514/' /etc/rsyslog.conf
	    sed -i 's/\#\\$ModLoad imtcp/\\$ModLoad imtcp/' /etc/rsyslog.conf
	    sed -i 's/\#\\$InputTCPServerRun 514/\\$InputTCPServerRun 514/' /etc/rsyslog.conf
	    service rsyslog restart
	  EOH
	  not_if { ::File.exists?('/var/log/haproxy.log') }
	end
```
- `bash` resource will configure the logging for Haproxy. `code` block will modify the `rsyslog.conf` and restarts it using `service rsyslog` command.

###Configure Haproxy
```ruby
	template "/etc/haproxy/haproxy.cfg" do
	  source "haproxy.cfg.erb"
	  owner "root"
	  group "root"
	  mode 00644
	  action :create
	  not_if "cat /etc/haproxy/haproxy.cfg | grep -ow 'listen postfix_haproxy' "
	end
```
- `template ` resource will replace the content of `haproxy.cfg` from the source file mentioned in the template.

###Start Service
```ruby
	service "haproxy" do
	  supports :restart => true, :status => true, :reload => true, :start => true
	  action [:enable, :start, :reload]
	end
```
- `service` resource will enable, start and reloads the haproxy service.

###Copy Haproxy Guard file 
```ruby
	cookbook_file "Postfix_Guard.sh" do
	  path "/root/Postfix_Guard.sh"
	  action :create_if_missing
	  mode 0700
	  owner "root"
	  group "root"
	end
```
- `cookbook_file` resource will copy `Postfix_Guard.sh` file from the cookbook to `root`

###Gaurd Haproxy for changes
```ruby
	bash 'Postfix Guard ' do
	  flags '-xv'
	  cwd '/root'
	  code <<-EOH
	    nohup /root/Postfix_Guard.sh #{node['HAProxy']['postfixASG']} #{node['HAProxy']['region']} &>  /tmp/Postfix_Guard.log &
	  EOH
	  not_if "ps aux | grep 'Postfix_Guard' | grep -v 'grep Postfix_Guard'"
	  action :run
	end
```
- `bash` resource will configure the postfix guard using the bash scripts mention in the `code` block.


Usage
-----

#### haproxy::default

Just include `haproxy` in your node's `run_list`:

	{
	  "name":"my_node",
	  "run_list": [
	    "recipe[haproxy]"
	  ]
	}


Attributes can also be passed using a json file from the node during the chef client run.

chef-client -j node,json
#### Example `node.json`

	{
	  "name": “haproxy",
	  "description": "haproxy attributes",	  
	    "agent" : {
	  “haproxy” : “mode”
	      }  
	}

License and Authors
-------------------
Authors: Suraj savita
#
contributors : Bibin w.
#
Copyright:: News UK Pvt. Ltd.
