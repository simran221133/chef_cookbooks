#
# 
# Recipe:: yum::default
#
# 
#


yum_globalconfig '/etc/yum.conf' do
  node['yum']['main'].each do |config, value|
    send(config.to_sym, value)
  end

  action :create
end
