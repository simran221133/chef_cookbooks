#
# Cookbook Name:: apt
# Recipe:: default
#
# 
# 
#
if node['apt']['compile_time_update'] && ( !::File.exist?('/var/lib/apt/periodic/update-success-stamp') || !::File.exist?(first_run_file) )
  e = bash 'apt-get-update at compile time' do
    code <<-EOH
      apt-get update
      touch #{first_run_file}
    EOH
    ignore_failure true
    only_if { apt_installed? }
    action :nothing
  end
  e.run_action(:run)
end

# Run apt-get update to create the stamp file
execute 'apt-get-update' do
  command 'apt-get update'
  ignore_failure true
  only_if { apt_installed? }
  not_if { ::File.exist?('/var/lib/apt/periodic/update-success-stamp') }
end

# For other recipes to call to force an update
execute 'apt-get update' do
  command 'apt-get update'
  ignore_failure true
  only_if { apt_installed? }
  action :nothing
end

# Automatically remove packages that are no longer needed for dependencies
execute 'apt-get autoremove' do
  command 'apt-get -y autoremove'
  only_if { apt_installed? }
  action :nothing
end

# Automatically remove .deb files for packages no longer on your system
execute 'apt-get autoclean' do
  command 'apt-get -y autoclean'
  only_if { apt_installed? }
  action :nothing
end

