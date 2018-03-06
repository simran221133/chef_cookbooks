#
# Cookbook Name:: haproxy
# Recipe:: default
#
# Copyright 2013, News UK
#
# All rights reserved - Do Not Redistribute
#


default['haproxy']['balance_algorithm'] = "roundrobin"
default['haproxy']['mode'] = "tcp"
default['HAProxy']['postfixASG'] = ""
default['HAProxy']['region']= node['awscli']['region']


#default['haproxy']['ip1']="0.0.0.0"
#default['haproxy']['ip2']="0.0.0.0"
