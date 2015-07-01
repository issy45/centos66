#
# Cookbook Name:: lamp
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# テンプレートから設定を上書き作成
template "/etc/sysconfig/iptables" do
  source "iptables"
  owner "root"
  group "root"
  mode 0600
  notifies :restart, 'service[iptables]'
end

# iptablesのサービスを指定
service "iptables" do
  supports :status => true, :restart => true, :reload => true
  action [:start, :enable]
end
