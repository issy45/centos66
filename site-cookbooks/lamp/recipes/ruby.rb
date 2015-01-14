#
# Cookbook Name:: lamp
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package 'git' do
  action :install
end

# rbenvグループを作成して/usr/local/rbenvを実行権限のユーザーを追加する(今回はvagrantユーザーとveeweeユーザーを追加していますお好みによって変更してください)
group "rbenv" do
  action :create
  members "vagrant"
  append true
end

# gitからrbenvを落としてくる(#{node.user}はrootです)
git "/usr/local/rbenv" do
  repository "git://github.com/sstephenson/rbenv.git"
  reference "master"
  action :checkout
  user node['user']
  group "rbenv"
end

# ruby-build用のpluginフォルダを作成する
directory "/usr/local/rbenv/plugins" do
  owner node['user']
  group "rbenv"
  mode "0755"
  action :create
end


# rbenvのbash設定を追加
template "/etc/profile.d/rbenv.sh" do
  owner node['user']
  group node['user']
  mode 0644
end

# ruby-buildを落としてくる
git "/usr/local/rbenv/plugins/ruby-build" do
  repository "git://github.com/sstephenson/ruby-build.git"
  reference "master"
  action :checkout
  user node['user']
  group "rbenv"
end