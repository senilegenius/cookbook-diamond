# install diamond and enable basic collectors

service "diamond" do
  action :nothing
end

include_recipe "diamond::install"

template "/etc/diamond/diamond.conf" do
  action :create
  source "diamond.conf.erb"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, resources(:service => "diamond")
end

template "/etc/init/diamond.conf" do
  source "diamond.erb"
  mode 0755
  owner "root"
  group "root"
  not_if { ::File.exists?("/etc/init/diamond.conf") }
end

cookbook_file "/etc/init.d/diamond" do
  source "diamond.init"
  mode 0755
  owner "root"
  group "root"
  not_if { ::File.exists?("/etc/init.d/diamond") }
end

# Install basic collector configs
include_recipe 'diamond::diskusage'
include_recipe 'diamond::diskspace'
include_recipe 'diamond::vmstat'
include_recipe 'diamond::memory'
include_recipe 'diamond::network'
include_recipe 'diamond::tcp'
include_recipe 'diamond::loadavg'
include_recipe 'diamond::cpu'
include_recipe 'diamond::filestat'
include_recipe 'diamond::ipmisensor'
include_recipe 'diamond::proc'
include_recipe 'diamond::slabinfo'

service "diamond" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end
