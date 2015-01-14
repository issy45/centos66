#
# Cookbook Name:: lamp
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# ruby 1.9.3-p392をインストール
execute "ruby install" do
  not_if "source /etc/profile.d/rbenv.sh; rbenv versions | grep #{node.version}"
  command "source /etc/profile.d/rbenv.sh; rbenv install #{node.version}"
  action :run
end

#globalの切り替え
execute "ruby change" do
  command "source /etc/profile.d/rbenv.sh; rbenv global #{node.version}; rbenv rehash"
  action :run
end