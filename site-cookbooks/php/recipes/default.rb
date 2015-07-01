#
# Cookbook Name:: lamp
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# PHPと関連するモジュールをインストールする
#  sudo yum install -y php
#  sudo yum install -y php-mbstring
#  sudo yum install -y php-mysql
%w(php php-mbstring php-mysql).each do |pkg|
  package pkg do
    action :install
  end
end